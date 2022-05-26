class CreateOrganizationalUnits < ActiveRecord::Migration[7.0]
  def change
    create_table :organizational_units do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.string :level_name
      t.integer :level_index

      t.timestamps
    end
  end
end
