class Job < ApplicationRecord
  validates :title, :description, :company, :location, :job_type, :salary, :apply_link, :experience_level, :industry, presence: true
  validates :salary, numericality: { greater_than: 0 }
  validate :salary_max_greater_than_salary_min
  validates :job_type, inclusion: { in: ['Remote', 'remote', 'REMOTE'] }
  validates :country, :city, :latitude, :longitude, presence: true
  validates :state, presence: true, if: :country_has_states?

  def country_has_states?
    ['US', 'CA', 'AU'].include?(country)
  end

  def full_location
    [city, country].compact.join(', ')
  end

  geocoded_by :full_location
  after_validation :geocode, if: ->(obj){ obj.full_location.present? && (obj.location_changed? || obj.country_changed?) }

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

  belongs_to :user, optional: true
  has_many :job_applications
  has_many :applicants, through: :job_applications, source: :user
  has_many :bookmarks
  has_many :bookmarking_users, through: :bookmarks, source: :user

  scope :featured, -> { where('featured_until > ?', Time.current).order(featured_until: :desc) }
  scope :regular, -> { where('featured_until IS NULL OR featured_until <= ?', Time.current) }

  def feature!
    update(featured_until: 7.days.from_now)
    user.decrement!(:featured_posts_available)
  end

  def formatted_salary
    "Starting at #{ActionController::Base.helpers.number_to_currency(salary, precision: 0)}"
  end
end
