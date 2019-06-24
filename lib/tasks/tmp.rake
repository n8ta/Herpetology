namespace :imports do
  desc "Import tmp"
  task tmp: :environment do

    def a(arr)
      arr << 10
    end

    x = []

    a(x)
    a(x)

    z = Thread.new {
      a(x)
    }

    z.join()

    puts x.inspect


  end
end
