json.id species.id
json.name species.name
json.genus species.genus


json.common_names species.common_names do |name|
  json.id name.id
  json.name name.name
end
