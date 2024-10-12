class JobApplication < ApplicationRecord
  belongs_to :job
  belongs_to :user

  validates :cover_letter, presence: true
  # Add any other fields you want for the job application
end
