json.id superfamily.id
json.name superfamily.name
json.url superfamily_url(superfamily, format: :json)

json.families superfamily.families do |family|
  json.id family.id
  json.name family.name
  json.url family_url(family, format: :json )
end
