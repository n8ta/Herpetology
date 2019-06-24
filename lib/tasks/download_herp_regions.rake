namespace :imports do
  desc "Download regions from herpmapper"
  task download_herp_regions: :environment do
    start = Time.now.to_i
    # herps is a set of arrays, each array contains a country,state,county triplet
    herps = {} # taxon: set([reg1,reg2,reg3]  )
    pages = 1..9842
    queue = Queue.new
    pages.each do |pg|
      queue << pg
    end

    def parse_herpmapper(page, herps)
      base_url = "http://www.herpmapper.org/records?p="
      start = Time.now.to_i
      response = HTTParty.get(base_url + page.to_s)
      endd = Time.now.to_i
      puts "Network: "+(endd-start).to_s
      html = Nokogiri::HTML(response.body)
      html.xpath(".//div[@id='content']").xpath('.//table').xpath(".//tr").each do |row|
        begin
          # Get tier info for geography
          geography = row.xpath(".//td[@class='hidden-xs']").text # Get the <td> with the geograpgy info
          geography = geography.split("\t").join(" ").split("\n")
          tier1 = geography[1].split(" ").join(" ")
          tier2 = geography[2].split(" ").join(" ")
          tier3 = geography[3].split(" ").join(" ")


          links = row.xpath('.//a')
          sci_name = links[2].text.split(" ").join(" ").split("\n").join(" ").titleize

          start = Time.now.to_i
          if herps[sci_name]
            herps[sci_name].add([tier1,tier2,tier3])
          else
            herps[sci_name] = Set[[tier1,tier2,tier3]]
          end
          end_t = Time.now.to_i


        rescue => error
          puts "Failed on " + sci_name.to_s + " page: " + page.to_s
          puts "  error: " + error.to_s
          puts "  trace: " + error.backtrace.to_s
          next
        end

      end
    end

    threads = []
    for x in 0..4
      threads << Thread.new {
        while queue.length != 0
          page = queue.pop
          puts "Starting page "+page.to_s
          begin
          parse_herpmapper(page, herps)
          rescue
            queue << page
          end
        end
      }
    end

    threads.each do |thr|
      thr.join()
    end


    File.open(Rails.root.join('lib', 'tasks', 'assets', 'herp_regions.json'), "w") do |fle|
      fle.write(herps.to_json)
    end

    puts Time.now.to_i-start

  end
end
