json.extract! region, :id, :name

@taxon = Taxon.find(params[:taxon_id])

json.subregions region.subregions_with_6(@taxon).each do |subregion|
  json.id subregion.id
  json.name subregion.name
  json.quiz_url game_path(@taxon, subregion.id, format: :json)
end
