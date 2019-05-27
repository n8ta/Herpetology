require 'dotenv/load'

def find_species(genus_txt, species_txt)
  ### Search models for the genus / species pair
  genus = Genus.where('lower(name) = ?', genus_txt.downcase).first
  species = genus.species.find_by('lower(name) = ?', species_txt.downcase)

  if species.nil?
    puts '  failed on: ' + genus_txt + ' ' + species_txt
    raise
  end
  return species
end

def countSubstrings(str, subStr)
  # How many substrings in that str??
  str.scan(subStr).length
end


namespace :imports do

  desc "Import posts for r/whatsthissnake"
  task reddit: :environment do
    session = Redd.it(
        user_agent: ENV['reddit_user_agent'],
        client_id: ENV['reddit_client_id'],
        secret: ENV['reddit_secret'],
        username: ENV['reddit_username'],
        password: ENV['reddit_password'],
    )

    total = 0
    images = 0

    bf = Bloomer.new(20000, 0.001)

    users = [session.user('phylogenizer'),
             session.user('unknown_name'),
             session.user('TheChuck42'),
             session.user('shrike1978'),
             session.user('smee0066'),
             session.user('Reggietoaster'),
             session.user('CirceMoon')]
    users.each do |user|
      comments = user.comments()
      while comments.after != nil do
        comments.each do |comment|
          total += 1
          num_stars = countSubstrings(comment.body, '*')
          next unless num_stars == 2
          comment.body.match(/\*(.+)\*/) {|m|
            m.captures.each do |match|

              if bf.include? comment.link_url
                puts "skipping due to bloom"
                next
              end
              bf.add comment.link_url

              next unless match.include?(" ") # must must 'genus--SPACE--species'
              next unless comment.link_url.match(/(?:jpg|gif|png)/)


              # parse the species info
              genus = match.split(' ')[0].downcase.capitalize
              species = match.split(' ')[1].downcase.capitalize

              begin
                species_model = find_species(genus, species)
              rescue
                next
              end

              # download and store the image
              response = HTTParty.get(comment.link_url)
              next unless response.code == 200
              data = response.body

              file_path = Rails.root.join('tmp/reddit/' + SecureRandom.hex(50) + File.extname(comment.link_url))

              File.open(file_path, "w") do |file|
                file.binmode
                file.write(data)
              end


              photo = Photo.new(species: species_model)
              photo.image_path = Pathname.new(file_path).open
              photo.original_url = comment.link_url
              photo.save!

              images += 1
              next
            end

          }


        end
        comments = user.comments(after: comments.after, limit: 1000)
        puts 'running images total: ' + images.to_s + '_' + total.to_s
      end
    end

    puts 'images count: ' + images.to_s
    puts 'final count: ' + total.to_s
    puts 'ratio: ' + ((images / total).to_s)
  end

end
