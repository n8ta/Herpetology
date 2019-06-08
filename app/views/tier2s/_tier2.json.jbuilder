json.extract! tier2, :id, :name, :tier1_id
json.url tier2_url(tier2, format: :json)

json.tier3s tier2.tier3s.each do | t3 |
  json.id t3.id
  json.name t3.name
  json.url tier3_url(t3.id, format: :json )
end
