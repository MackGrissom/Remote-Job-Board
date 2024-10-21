class AddLocationFieldsToJobApplications < ActiveRecord::Migration[8.0]
  def change
    add_column :job_applications, :country, :string
    add_column :job_applications, :region, :string
    add_column :job_applications, :city, :string
  end
end
