json.id family.id
json.name family.name
json.superfamily family.superfamily

json.genera family.genera do |genus|
  json.id genus.id
  json.name genus.name
  json.url genus_url(genus, format: :json )
end
