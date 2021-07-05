class ChangeUsernameToEmail < ActiveRecord::Migration[6.1]
  def change
    rename_column :patients, :username, :email
    rename_column :providers, :username, :email
  end
end
