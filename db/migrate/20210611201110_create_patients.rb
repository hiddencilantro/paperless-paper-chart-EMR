class CreatePatients < ActiveRecord::Migration[6.1]
  def change
    create_table :patients do |t|
      t.string :name
      t.integer :sex, limit: 1, default: 0
      t.date :dob

      t.timestamps
    end
    add_index :patients, :sex
  end
end
