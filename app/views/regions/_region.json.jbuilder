json.extract! region, :id, :name

@taxon = Taxon.find(params[:taxon_id])
json.subregions @taxon.valid_regions.where(region: @region).each do |subregion|
  json.id subregion.id
  json.name subregion.name
  json.quiz_url quiz_game_path(@taxon, subregion.id)
end
