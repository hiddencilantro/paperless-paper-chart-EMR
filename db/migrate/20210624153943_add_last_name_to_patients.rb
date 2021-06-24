class AddLastNameToPatients < ActiveRecord::Migration[6.1]
  def change
    add_column :patients, :last_name, :string
  end
end
