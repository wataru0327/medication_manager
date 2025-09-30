# db/seeds.rb

# === ユーザー作成 ===
doctor = User.find_or_create_by!(email: "doctor@example.com") do |u|
  u.name = "Dr. Tanaka"
  u.role = :doctor
  u.password = "password"
  u.password_confirmation = "password"
end

patient = User.find_or_create_by!(email: "patient@example.com") do |u|
  u.name = "Suzuki Taro"
  u.role = :patient
  u.password = "password"
  u.password_confirmation = "password"
end

pharmacy = User.find_or_create_by!(email: "pharmacy@example.com") do |u|
  u.name = "Central Pharmacy"
  u.role = :pharmacy
  u.password = "password"
  u.password_confirmation = "password"
end

# === 処方箋作成 ===
prescription = Prescription.find_or_create_by!(
  patient: patient,
  doctor: doctor,
  qr_token: SecureRandom.uuid
) do |p|
  p.patient_name = patient.name
  p.issued_at    = Time.current
  p.expires_at   = 7.days.from_now
end

# === 薬情報作成 ===
Medication.find_or_create_by!(name: "胃薬") do |m|
  m.dosage = "1錠"
  m.timing = :morning
end

Medication.find_or_create_by!(name: "風邪薬") do |m|
  m.dosage = "2錠"
  m.timing = :evening
end

# === ステータス更新履歴 ===
StatusUpdate.find_or_create_by!(
  prescription: prescription,
  pharmacy: pharmacy,
  status: :pending
)

puts "✅ Seed data created successfully!"

