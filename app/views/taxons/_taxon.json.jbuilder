json.id @taxon.id
json.name @taxon.sci_name
json.venomous @taxon.venomous if @taxon.rank == "species"
json.common_name @taxon.common_name

json.countries @taxon.regions.countries.select {|reg| reg.taxons.species.includes(:photos).where(root_taxon_id: @taxon.root.id).select { |sp| sp.photos.any? }.size > 5 }.each do |rgn|
  json.id rgn.id
  json.name rgn.name
  json.game_url game_taxon_region_url(@taxon, rgn.id, "game")
  json.url taxon_region_url(@taxon, rgn.id)
end
