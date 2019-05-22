json.extract! photo, :id, :species_id, :image_path, :seen, :correct, :created_at, :updated_at
json.url photo_url(photo, format: :json)
