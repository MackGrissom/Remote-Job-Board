class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :jobs
  has_many :job_applications
  has_many :bookmarks
  has_many :bookmarked_jobs, through: :bookmarks, source: :job
  # ... other associations and validations ...

  def update_subscription(package)
    case package
    when 'single'
      self.job_posts_available = (self.job_posts_available || 0) + 1
      self.subscription_expires_at = 60.days.from_now
    when 'monthly'
      self.job_posts_available = 20
      self.subscription_expires_at = 30.days.from_now
    when 'featured'
      self.featured_posts_available = (self.featured_posts_available || 0) + 1
      self.featured_expires_at = 7.days.from_now
    end
    save
  end

  def can_post_job?
    (job_posts_available || 0) > 0 && (subscription_expires_at || 1.day.ago) > Time.current
  end

  def can_feature_job?
    (featured_posts_available || 0) > 0 && (featured_expires_at || 1.day.ago) > Time.current
  end
end
