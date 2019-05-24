json.extract! superfamily, :id, :name, :created_at, :updated_at, :url
json.families superfamily.families
json.url superfamily_url(superfamily, format: :json)
