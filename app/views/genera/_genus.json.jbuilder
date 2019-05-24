json.id genus.id
json.name genus.name
json.family genus.family

json.species genus.species do |specie|
  json.id specie.id
  json.name specie.name
  json.url species_url(specie, format: :json )
end
