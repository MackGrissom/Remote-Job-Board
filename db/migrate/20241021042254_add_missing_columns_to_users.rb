class AddMissingColumnsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :subscription_expires_at, :datetime
    add_column :users, :featured_posts_available, :integer
    add_column :users, :featured_expires_at, :datetime
  end
end
