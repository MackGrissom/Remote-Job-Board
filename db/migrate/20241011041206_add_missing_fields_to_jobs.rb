class AddMissingFieldsToJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :jobs, :industry, :string unless column_exists?(:jobs, :industry)
    add_column :jobs, :experience_level, :string unless column_exists?(:jobs, :experience_level)
    
    unless column_exists?(:jobs, :salary_min)
      add_column :jobs, :salary_min, :decimal, precision: 10, scale: 2
    end
    
    unless column_exists?(:jobs, :salary_max)
      add_column :jobs, :salary_max, :decimal, precision: 10, scale: 2
    end
    
    remove_column :jobs, :salary, :decimal if column_exists?(:jobs, :salary)
  end
end