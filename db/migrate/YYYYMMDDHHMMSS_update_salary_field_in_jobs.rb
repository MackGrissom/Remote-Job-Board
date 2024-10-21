class UpdateSalaryFieldInJobs < ActiveRecord::Migration[6.1]
  def change
    remove_column :jobs, :salary_min, :decimal
    remove_column :jobs, :salary_max, :decimal
    add_column :jobs, :salary, :integer
  end
end
