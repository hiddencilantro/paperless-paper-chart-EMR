class CreateSoaps < ActiveRecord::Migration[6.1]
  def change
    create_table :soaps do |t|
      t.references :encounter, null: false, foreign_key: true
      t.text :chief_complaint
      t.text :subjective
      t.text :objective
      t.text :assessment_and_plan

      t.timestamps
    end
  end
end
