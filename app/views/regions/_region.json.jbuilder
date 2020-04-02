json.extract! region, :id, :name

@taxon = Taxon.find(params[:taxon_id])
json.subregions @taxon.valid_regions.where(region: @region).each do |subregion|
  json.id subregion.id
  json.name subregion.name
  json.game_url game_taxon_region_url(@taxon, subregion.id,"game")
end

json.taxons @region.taxons.species.where(root_taxon_id: @taxon.id, photographed: true).select {|sp| sp.photos.any?}.each do |taxon|
  json.id taxon.id
  json.scientific_name taxon.name
  json.common_name taxon.common_name
  # json.photos taxon.photos.map { |p| p.image_path.url }
end