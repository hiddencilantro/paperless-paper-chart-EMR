class CreateEncounters < ActiveRecord::Migration[6.1]
  def change
    create_table :encounters do |t|
      t.references :provider, null: false, foreign_key: true
      t.references :patient, null: false, foreign_key: true
      t.text :chief_complaint
      t.text :subjective
      t.text :objective
      t.text :assessment_and_plan

      t.timestamps
    end
  end
end
