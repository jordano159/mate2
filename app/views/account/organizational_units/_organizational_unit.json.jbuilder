json.extract! organizational_unit,
  :id,
  :team_id,
  :name,
  :level_name,
  :level_index,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url account_organizational_unit_url(organizational_unit, format: :json)
