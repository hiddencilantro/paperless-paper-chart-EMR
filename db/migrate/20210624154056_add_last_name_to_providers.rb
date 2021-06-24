class AddLastNameToProviders < ActiveRecord::Migration[6.1]
  def change
    add_column :providers, :last_name, :string
  end
end
