class JobApplication < ApplicationRecord
  belongs_to :user
  belongs_to :job

  has_one_attached :resume

  validates :full_name, :email, :phone, :linkedin_url, :cover_letter, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :linkedin_url, format: { with: /\A(https?:\/\/)?(www\.)?linkedin\.com\/in\/.*\z/ }
  validate :resume_attached_and_valid

  private

  def resume_attached_and_valid
    if resume.attached?
      unless resume.content_type.in?(%w[application/pdf])
        errors.add(:resume, 'must be a PDF')
      end
    else
      errors.add(:resume, 'must be attached')
    end
  end
end
