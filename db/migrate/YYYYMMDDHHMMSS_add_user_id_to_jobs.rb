class AddUserIdToJobs < ActiveRecord::Migration[6.1]  # The version number might be different
  def up
    add_reference :jobs, :user, foreign_key: true
    
    # Assign a default user to existing jobs
    # You might want to create a default user for this purpose
    default_user = User.first || User.create!(email: 'default@example.com', password: 'password')
    
    Job.update_all(user_id: default_user.id)
    
    change_column_null :jobs, :user_id, false
  end

  def down
    remove_reference :jobs, :user
  end
end
