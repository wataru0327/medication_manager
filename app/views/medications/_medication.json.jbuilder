json.extract! medication, :id, :prescription_id, :name, :dosage, :timing, :created_at, :updated_at
json.url medication_url(medication, format: :json)
