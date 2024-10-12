class Job < ApplicationRecord
  validates :title, :description, :company, :location, :job_type, :salary_min, :salary_max, :apply_link, :experience_level, :industry, presence: true
  validates :salary_min, :salary_max, numericality: { greater_than_or_equal_to: 0 }
  validate :salary_max_greater_than_salary_min

  geocoded_by :location
  after_validation :geocode, if: ->(obj){ obj.location.present? && obj.location_changed? }

  def geocode
    begin
      super
    rescue Geocoder::Error => e
      Rails.logger.error "Geocoding error: #{e.message}"
    end
  end

  private

  def salary_max_greater_than_salary_min
    if salary_min && salary_max && salary_max < salary_min
      errors.add(:salary_max, "must be greater than or equal to salary_min")
    end
  end

  def self.filter(params)
    jobs = all

    jobs = jobs.where("title ILIKE ?", "%#{params[:title]}%") if params[:title].present?
    jobs = jobs.where("company ILIKE ?", "%#{params[:company]}%") if params[:company].present?
    jobs = jobs.where("location ILIKE ?", "%#{params[:location]}%") if params[:location].present?
    jobs = jobs.where(job_type: params[:job_type]) if params[:job_type].present?
    jobs = jobs.where(experience_level: params[:experience_level]) if params[:experience_level].present?
    jobs = jobs.where(industry: params[:industry]) if params[:industry].present?

    if params[:salary_min].present? && params[:salary_max].present?
      jobs = jobs.where("salary_min >= ? AND salary_max <= ?", params[:salary_min].to_f, params[:salary_max].to_f)
    elsif params[:salary_min].present?
      jobs = jobs.where("salary_min >= ?", params[:salary_min].to_f)
    elsif params[:salary_max].present?
      jobs = jobs.where("salary_max <= ?", params[:salary_max].to_f)
    end

    jobs
  end

  belongs_to :user
  has_many :job_applications
  has_many :applicants, through: :job_applications, source: :user
end
