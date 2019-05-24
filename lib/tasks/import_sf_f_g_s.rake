namespace :import_sf_f_g_s do

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
