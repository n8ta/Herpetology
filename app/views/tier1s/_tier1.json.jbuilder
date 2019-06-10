json.extract! tier1, :id, :name
# json.url tier1_url(tier1, format: :json)

@taxon = Taxon.find(params[:taxon_id])

json.tier2s tier1.tier2s_with_6_photographed_species_for_taxon(@taxon).each do |t2|
  json.id t2.id
  json.name t2.name
  json.url taxon_tier2_url(@taxon, t2.id, format: :json)
  json.quiz_url t2_taxon_quiz_url(@taxon, t2.id)
end
