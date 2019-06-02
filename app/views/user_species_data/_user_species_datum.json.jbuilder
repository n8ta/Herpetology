json.extract! user_species_datum, :seen, :correct
json.species do
  json.id user_species_datum.species.id
  json.name user_species_datum.species.name
  json.common_names user_species_datum.species.common_names do |name|
    json.id name.id
    json.name name.name
  end

  json.genus do
    json.id user_species_datum.species.genus.id
    json.name user_species_datum.species.genus.name
  end


end