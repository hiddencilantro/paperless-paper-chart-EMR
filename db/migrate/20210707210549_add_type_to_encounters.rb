class AddTypeToEncounters < ActiveRecord::Migration[6.1]
  def change
    add_column :encounters, :encounter_type, :integer, limit: 1
    add_index :encounters, :encounter_type
  end
end
