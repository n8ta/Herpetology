# Rake::Task['imports:herp_create_regions'].invoke ## Create the region.rb models
# Rake::Task['imports:taxonomy'].invoke ## Create the taxon.rb models
# Rake::Task['imports:herp_regions'].invoke ## Taxon the taxons with regions in the join table
# Rake::Task['imports:herp_photos'].invoke ## Import all the photos (LONGGG)
#
# ## Calculate the regions for the root taxons for easy access, this prevents N+1 queries later but denormalizes
# Rake::Task['maintenance:update_regions_root_taxons_table'].invoke
#
# ## Store whether or not a taxon has been photographed on the model, again denormalizes but necessary for speed
# Rake::Task['maintenance:update_taxon_validity'].invoke
#
# Rake::Task['imports:root_taxon_photos']


g = Group.create(name: "Venomous Snakes of the USA and their lookalikes")
g.taxons << Taxon.find_by(name: "Agkistrodon Contortrix")
g.taxons << Taxon.find_by(name: "Crotalus Horridus")
g.taxons << Taxon.find_by(name: "Crotalus oreganus")
g.taxons << Taxon.find_by(name: "Crotalus tigris")
g.taxons << Taxon.find_by(name: "Micrurus fulvius")
g.taxons << Taxon.find_by(name: "Crotalus atrox")
g.taxons << Taxon.find_by(name: "Crotalus adamanteus")
g.taxons << Taxon.find_by(name: "Crotalus viridis")
g.taxons << Taxon.find_by(name: "Crotalus scutulatus")

Region.find(236).taxons.species.where(venomous: true).each do |taxon|
  g.taxons << taxon
end
