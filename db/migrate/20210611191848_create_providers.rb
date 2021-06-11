class CreateProviders < ActiveRecord::Migration[6.1]
  def change
    create_table :providers do |t|
      t.string :name
      t.string :username
      t.string :password_digest

      t.timestamps
    end
    add_index :providers, :username, unique: true
  end
end
