class AddSubscriptionFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :job_posts_available, :integer, default: 0
    add_column :users, :subscription_expires_at, :datetime
    add_column :users, :featured_posts_available, :integer, default: 0
    add_column :users, :featured_expires_at, :datetime
  end
end
