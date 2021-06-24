class RenameProviderNameToFirstName < ActiveRecord::Migration[6.1]
  def change
    rename_column :providers, :name, :first_name
  end
end
