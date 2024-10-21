class AddDetailsToJobApplications < ActiveRecord::Migration[8.0]
  def change
    add_column :job_applications, :full_name, :string
    add_column :job_applications, :email, :string
    add_column :job_applications, :phone, :string
    add_column :job_applications, :linkedin_url, :string
  end
end
