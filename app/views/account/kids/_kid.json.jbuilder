json.extract! kid,
  :id,
  :team_id,
  :name,
  :sex,
  :phone,
  :grade,
  :attendance_status,
  :attendance_note,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url account_kid_url(kid, format: :json)
