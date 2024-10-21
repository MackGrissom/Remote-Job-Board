class AddJobPostsAvailableToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :job_posts_available, :integer
  end
end
