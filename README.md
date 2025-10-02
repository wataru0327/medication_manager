# Medication Manager
# 処方箋管理アプリ (Medication Manager)

## 概要
本アプリは、**医師・薬局・患者**の3者をつなぐ処方箋管理システムです。  
処方箋を **QRコード** で安全に受け渡しし、患者がアプリを通じて処方内容を確認でき、  
さらに **服薬通知機能** によって飲み忘れを防止することを目的としています。  

---

## ユーザーと役割
- **医師 (Doctor)**
  - 患者に処方箋を発行
  - QRコードを生成して渡す  

- **薬局 (Pharmacy)**
  - 患者のQRコードを読み取り処方箋を取得
  - 調剤ステータスを更新（受付中 → 調剤中 → 受け渡し済み）  

- **患者 (Patient)**
  - QRコードを受け取り、薬局で提示
  - アプリで処方内容とステータスを確認
  - 服薬リマインド通知を受け取る  

---

## データベース設計

### Users（共通ユーザー）
- `id`
- `name` (string)
- `email` (string, unique)
- `role` (enum: doctor / pharmacy / patient)

**バリデーション**
- name: presence
- email: presence, uniqueness, format
- role: inclusion

**アソシエーション**
- doctor → has_many :prescriptions, foreign_key: :doctor_id  
- patient → has_many :prescriptions, foreign_key: :patient_id  
- pharmacy → has_many :status_updates  

---

### Prescriptions（処方箋）
- `id`
- `patient_id` (FK: Users.id)
- `doctor_id` (FK: Users.id)
- `issued_at` (datetime)
- `expires_at` (datetime)
- `qr_token` (UUID, unique)

**バリデーション**
- patient_id, doctor_id, issued_at, expires_at, qr_token: presence
- expires_at > issued_at
- qr_token: uniqueness

**アソシエーション**
- belongs_to :patient, class_name: "User"
- belongs_to :doctor, class_name: "User"
- has_many :medications, dependent: :destroy
- has_many :status_updates, dependent: :destroy  

---

### Medications（薬情報）
- `id`
- `prescription_id` (FK)
- `name` (string)
- `dosage` (string)
- `timing` (enum: morning / noon / evening / bedtime)

**バリデーション**
- name, dosage, timing: presence
- timing: inclusion

**アソシエーション**
- belongs_to :prescription  

---

### StatusUpdates（ステータス履歴）
- `id`
- `prescription_id` (FK)
- `pharmacy_id` (FK: Users.id)
- `status` (enum: pending / processing / completed)

**バリデーション**
- prescription_id, pharmacy_id, status: presence
- status: inclusion

**アソシエーション**
- belongs_to :prescription
- belongs_to :pharmacy, class_name: "User"

---

## 技術スタック
- **フレームワーク**: Ruby on Rails
- **DB**: PostgreSQL
- **QRコード生成**: rqrcode gem
- **デプロイ**: Render

---

## 今後の拡張
- 患者アプリをPWA化し、プッシュ通知対応  
- 医師・薬局ごとのログイン認証強化  
- 電子カルテとの連携  

---

## ER図
```mermaid
erDiagram
    User ||--o{ Prescription : "creates / receives"
    User ||--o{ StatusUpdate : "manages"
    Prescription ||--o{ Medication : "includes"
    Prescription ||--o{ StatusUpdate : "has"

    User {
        int id PK
        string name
        string email (unique)
        enum role // doctor / pharmacy / patient
    }

    Prescription {
        int id PK
        int patient_id FK -> User.id
        int doctor_id FK -> User.id
        datetime issued_at
        datetime expires_at
        string qr_token (UUID, unique)
    }

    Medication {
        int id PK
        int prescription_id FK -> Prescription.id
        string name
        string dosage
        enum timing // morning / noon / evening / bedtime
    }

    StatusUpdate {
        int id PK
        int prescription_id FK -> Prescription.id
        int pharmacy_id FK -> User.id
        enum status // pending / processing / completed
    }
```

セットアップ方法
前提条件
Ruby 3.2.x

Rails 7.1.x

PostgreSQL がインストールされていること

手順
# リポジトリをクローン
git clone https://github.com/yourname/medication_manager.git
cd medication_manager

# 依存関係をインストール
bundle install

# データベースを作成
bin/rails db:create db:migrate

# サーバーを起動
bin/rails s
ブラウザで以下を開いてください：
👉 http://localhost:3000


