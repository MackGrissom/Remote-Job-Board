class AddCoverLetterToJobApplications < ActiveRecord::Migration[8.0]
  def change
    add_column :job_applications, :cover_letter, :text
  end
end
