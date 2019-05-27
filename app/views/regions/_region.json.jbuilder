json.id region.id
json.name region.name
json.url region_url(region, format: :json)

json.species region.species do |specie|
  json.id specie.id
  json.name specie.name
  json.url species_url(specie.id, format: :json)
  json.genus do
    json.id specie.genus.id
    json.name specie.genus.name
    json.url genus_url(specie.genus, format: :json)
  end

  json.common_names specie.common_names do |name|
    json.name name.name
  end

end