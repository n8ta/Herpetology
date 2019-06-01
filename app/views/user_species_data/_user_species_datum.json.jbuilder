json.extract! user_species_datum, :seen, :correct
begin
  json.image_url user_species_datum.species.photos[0].image_path.url
rescue
  json.image_url nil
end

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