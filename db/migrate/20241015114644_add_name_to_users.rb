class AddNameToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :last_name, :string unless column_exists?(:users, :last_name)
  end
end
