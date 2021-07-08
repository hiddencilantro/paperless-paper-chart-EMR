class CreatePatientsProviders < ActiveRecord::Migration[6.1]
  def change
    create_table :patients_providers do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :provider, null: false, foreign_key: true

      t.timestamps
    end
  end
end
