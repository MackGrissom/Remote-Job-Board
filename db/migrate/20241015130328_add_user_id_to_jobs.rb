class AddUserIdToJobs < ActiveRecord::Migration[6.1]
  def change
    add_reference :jobs, :user, null: true, foreign_key: true
  end
end
