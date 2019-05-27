# SEEDING:
# In this order:
# imports:taxnomy
# imports:pitt
# db:seed
# imports:regions

genus = Genus.find_by(name: 'Agkistrodon')
Species.new(name: 'Laticinctus', genus: genus).save!

genus = Genus.find_by(name: 'Sonora')
Species.new(name: 'Occipitalis', genus: genus).save!

genus = Genus.find_by(name: 'Agkistrodon')
Species.new(name: 'Conanti', genus: genus).save!

genus = Genus.find_by(name: 'Pseustes')
Species.new(name: 'Poecilonotus', genus: genus).save!

genus = Genus.find_by(name: 'Lampropeltis')
Species.new(name: 'Rhombomaculata', genus: genus).save!

genus = Genus.find_by(name: 'Carphophis')
Species.new(name: 'Ameonus', genus: genus).save!

genus = Genus.find_by(name: 'Dendrelaphis')
Species.new(name: 'Inornatus', genus: genus).save!

nae = Region.new(name: "North America East")
naw = Region.new(name: "North America West")
nae.save!
naw.save!