class CreateOrganizationalUnitHierarchies < ActiveRecord::Migration[7.0]
  def change
    create_table :organizational_unit_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :organizational_unit_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "organizational_unit_anc_desc_idx"

    add_index :organizational_unit_hierarchies, [:descendant_id],
      name: "organizational_unit_desc_idx"
  end
end
