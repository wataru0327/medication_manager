# db/seeds.rb

# ユーザー作成
doctor = User.create!(
  name: "Dr. Tanaka",
  email: "doctor@example.com",
  role: :doctor
)

patient = User.create!(
  name: "Suzuki Taro",
  email: "patient@example.com",
  role: :patient
)

pharmacy = User.create!(
  name: "Central Pharmacy",
  email: "pharmacy@example.com",
  role: :pharmacy
)

# 処方箋作成
prescription = Prescription.create!(
  patient: patient,
  doctor: doctor,
  issued_at: Time.current,
  expires_at: 7.days.from_now,
  qr_token: SecureRandom.uuid
)

# 薬情報作成
Medication.create!(
  prescription: prescription,
  name: "胃薬",
  dosage: "1錠",
  timing: :morning
)

Medication.create!(
  prescription: prescription,
  name: "風邪薬",
  dosage: "2錠",
  timing: :evening
)

# ステータス更新履歴
StatusUpdate.create!(
  prescription: prescription,
  pharmacy: pharmacy,
  status: :pending
)

puts "✅ Seed data created successfully!"
