json.extract! user_taxon_datum, :sci_seen, :sci_correct, :common_seen, :common_correct
json.species do
  json.id user_taxon_datum.taxon.id
  json.name user_taxon_datum.taxon.name
  json.common_names user_taxon_datum.taxon.common_names do |name|
    json.id name.id
    json.name name.name
  end

  json.genus do
    json.id user_taxon_datum.taxon.taxon.id
    json.name user_taxon_datum.taxon.taxon.name
  end

end