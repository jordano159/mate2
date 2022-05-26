class AddParentIdToOrganizationalUnit < ActiveRecord::Migration[7.0]
  def change
    add_column :organizational_units, :parent_id, :integer
  end
end
