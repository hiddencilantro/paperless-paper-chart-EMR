class RemoveColumnsFromEncounters < ActiveRecord::Migration[6.1]
  def change
    remove_column :encounters, :chief_complaint, :text
    remove_column :encounters, :subjective, :text
    remove_column :encounters, :objective, :text
    remove_column :encounters, :assessment_and_plan, :text
  end
end
