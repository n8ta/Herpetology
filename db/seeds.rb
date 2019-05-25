# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

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

genus = Genus.find_by(name: 'Carphophis')
Species.new(name: 'Ameonus', genus: genus).save!

