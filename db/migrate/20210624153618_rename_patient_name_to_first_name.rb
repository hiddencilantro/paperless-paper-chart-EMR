class RenamePatientNameToFirstName < ActiveRecord::Migration[6.1]
  def change
    rename_column :patients, :name, :first_name
  end
end
