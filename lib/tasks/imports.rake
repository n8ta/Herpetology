

namespace :imports do
  desc "Import taxonomy from html file"

  debug = true
  unless debug
    def puts(text)
    end
  end

  # Imports data from https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi
  # to build out the taxonomy

  task taxonomy: :environment do
    text = IO.read(Rails.root.join('lib','tasks','taxonomy.html'))
    html_doc = Nokogiri::HTML(text)

    super_families = html_doc.xpath("//a[@title='superfamily']").map { | link | link.parent } # go from the <a> -> <li>

    puts 'Superfamilies: '+super_families.length.to_s

    super_families.each do |superfamily|

      super_family_name = superfamily.xpath("a[@title='superfamily']").xpath('./strong').text
      sfm = Superfamily.new(name: super_family_name)
      sfm.save!
      puts 'Superfamily: '+super_family_name.to_s

      families = superfamily.xpath(".//a[@title='family']").map { | fam | fam.parent}
      puts "Families: "+families.length.to_s

      families.each do |family|

        family_name = family.xpath("a[@title='family']").xpath('./strong').text
        fm = Family.new(name: family_name, superfamily: sfm)
        fm.save!
        puts '  Family: '+family_name.to_s

        genera = family.xpath(".//a[@title='genus']").map { | link | link.parent }
        puts '  Genera: '+genera.length.to_s
        genera.each do | genus |


          genus_name = genus.xpath("a[@title='genus']").xpath('./strong').text
          puts '    Genus: '+genus_name.to_s
          gm = Genus.new(name: genus_name, family: fm)
          gm.save!

          species = genus.xpath(".//a[@title='species']").map { | link | link.parent }
          puts '    Species: '+species.length.to_s

          species.each do |specie| ## We really need a singular for species....
            specie_name = specie.xpath("a[@title='species']").xpath('./strong').text.split("\n").join(" ").split(" ").join(" ")
            specie_name = specie_name.split(" ")[1] if specie_name.split(" ")[0] == genus_name
            specie_name = specie_name.downcase.capitalize

            sm = Species.new(name: specie_name, genus: gm)
            sm.save!

            text=specie.text

            begin

            if text.include?("(")
              common_name = text.split("(")[1].split(")")[0].split("\n").join(" ").split(" ").join(" ")
              cnm = CommonName.new(name:common_name, species: sm)
              cnm.save!
            end
            rescue
              # so it goes
            end

          end

        end

      end


    end
    puts 'done'
    x=  1
  end

  desc "Import posts for r/whatsthissnake"
  task reddit: :environment do
    session = Redd.it(
        user_agent: 'n8ta:snake_bot:v1 (by /u/Locke54)',
        client_id:  'lypo344XJRup3Q',
        secret:     'mArwHOC2yzbQFJAcsWd_261CiGY',
        username:   'Locke54',
        password:   'NEzZdTRt9Rs9u2Gok6Rid6oA3afXoWix'
    )

    puts session
    user = session.user('phylogenizer')
    methods = user.methods


    total = 0
    images = 0

    comments = user.comments()
    while comments.after != nil do
      comments.each do |comment|
        total += 1

        comment.body.match(/\*(.+)\*/) { | m |
          m.captures.each do | match |
            next unless match.include?(" ") # must must 'genus--SPACE--species'
            next unless comment.link_url.match(/(?:jpg|gif|png)/)

            # parse the species info
            genus = match.split(' ')[0]
            species = match.split(' ')[0]
            puts genus+' '+species
            puts comment.link_url

            # download and store the image

            response = HTTParty.get(comment.link_url)
            next unless response.code == 200
            data = response.body


            images += 1
            next
          end

        }


      end
      comments = user.comments(after: comments.after)
      puts 'running images total: '+images.to_s+'_'+total.to_s
    end

    puts 'images count: '+images.to_s
    puts 'final count: '+count.to_s
    puts 'ratio: '+((images/count).to_s)
  end

end
