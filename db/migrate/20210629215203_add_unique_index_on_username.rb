class AddUniqueIndexOnUsername < ActiveRecord::Migration[6.1]
  def change
    add_index :patients, :username, unique: true
  end
end
