class CreateJobApplications < ActiveRecord::Migration[6.1]
  def change
    create_table :job_applications do |t|
      t.references :job, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :cover_letter
      # Add any other fields you want for the job application

      t.timestamps
    end
  end
end
