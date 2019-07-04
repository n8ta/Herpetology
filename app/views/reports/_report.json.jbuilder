json.extract! report, :id, :created_by, :type, :taxon_id, :photo_id, :handled, :handled_by, :created_at, :updated_at
json.url report_url(report, format: :json)
