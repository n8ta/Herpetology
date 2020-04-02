FactoryBot.define do

  factory :tip do
    txns = Region.find(236).taxons
    content { Faker::Quote.famous_last_words }
    taxon { txns[rand(max=txns.size)]}
    user { User.all[rand(max=User.all.size)]}
  end

end