class Api::V1::OrganizationalUnitSerializer < Api::V1::ApplicationSerializer
  set_type "organizational_unit"

  attributes :id,
    :team_id,
    :name,
    :level_name,
    :level_index,
    # 🚅 super scaffolding will insert new fields above this line.
    :created_at,
    :updated_at

  belongs_to :team, serializer: Api::V1::TeamSerializer
end
