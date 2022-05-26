class CreateKidOrganizationalUnits < ActiveRecord::Migration[7.0]
  def change
    create_table :kid_organizational_units do |t|
      t.references :organizational_unit, null: false, foreign_key: true
      t.references :kid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
