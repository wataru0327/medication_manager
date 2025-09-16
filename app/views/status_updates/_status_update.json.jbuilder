json.extract! status_update, :id, :prescription_id, :pharmacy_id, :status, :created_at, :updated_at
json.url status_update_url(status_update, format: :json)
