class JobApplication < ApplicationRecord
  belongs_to :user
  belongs_to :job

  has_one_attached :resume

  validates :full_name, :email, :cover_letter, :country, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  private

  def resume_attached_and_valid
    if resume.attached?
      unless resume.content_type.in?(%w[application/pdf])
        errors.add(:resume, 'must be a PDF')
      end
    end
  end
end
