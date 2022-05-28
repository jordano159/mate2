class AddPreferencesToOrganizationalUnit < ActiveRecord::Migration[7.0]
  def change
    add_column :organizational_units, :preferences, :jsonb
  end
end
