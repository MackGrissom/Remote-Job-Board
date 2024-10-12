class AddIndustryToJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :industry, :string
  end
end
