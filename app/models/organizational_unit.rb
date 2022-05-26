class OrganizationalUnit < ApplicationRecord
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :team
  # 🚅 add belongs_to associations above.

  has_many :kid_organizational_units, dependent: :destroy
  has_many :kids, through: :kid_organizational_units
  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :name, presence: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_kids
    # raise "please review and implement `valid_kids` in `app/models/organizational_unit.rb`."
    # please specify what objects should be considered valid for assigning to `kid_ids`.
    # the resulting code should probably look something like `team.kids`.
    team.kids
  end

  # 🚅 add methods above.
end
