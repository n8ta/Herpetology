json.extract! region, :id, :name

@taxon = Taxon.find(params[:taxon_id])
json.subregions @taxon.valid_regions.where(region: @region).each do |subregion|
  json.id subregion.id
  json.name subregion.name
  json.quiz_url game_taxon_region_path(@taxon, subregion.id, "quiz")
  json.learn_url game_taxon_region_path(@taxon, subregion.id, "learn")

end
