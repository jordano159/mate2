class Api::V1::KidSerializer < Api::V1::ApplicationSerializer
  set_type "kid"

  attributes :id,
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

  belongs_to :team, serializer: Api::V1::TeamSerializer
end
