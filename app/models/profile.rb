class Profile < ApplicationRecord
  belongs_to :user
  # Remove first_name and last_name validations if they exist
  # Add any other profile-specific validations here
end
