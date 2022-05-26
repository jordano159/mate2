class CreateKids < ActiveRecord::Migration[7.0]
  def change
    create_table :kids do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.string :sex
      t.string :phone
      t.string :grade
      t.integer :attendace_status, default: 0
      t.string :attendance_note

      t.timestamps
    end
  end
end
