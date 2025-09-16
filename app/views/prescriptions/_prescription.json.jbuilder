json.extract! prescription, :id, :patient_id, :doctor_id, :issued_at, :expires_at, :qr_token, :created_at, :updated_at
json.url prescription_url(prescription, format: :json)
