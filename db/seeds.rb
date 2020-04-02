Rake::Task['imports:herp_create_regions'].invoke ## Create the region.rb models
Rake::Task['imports:taxonomy'].invoke ## Create the taxon.rb models
Rake::Task['imports:herp_regions'].invoke ## Taxon the taxons with regions in the join table
Rake::Task['imports:herp_photos'].invoke ## Import all the photos (LONGGG)

## Calculate the regions for the root taxons for easy access, this prevents N+1 queries later but denormalizes
Rake::Task['maintenance:update_regions_root_taxons_table'].invoke

## Store whether or not a taxon has been photographed on the model, again denormalizes but necessary for speed
Rake::Task['maintenance:update_taxon_validity'].invoke

Rake::Task['imports:root_taxon_photos']