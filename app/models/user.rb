class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :jobs
  has_many :job_applications
  # ... other associations and validations ...
end
