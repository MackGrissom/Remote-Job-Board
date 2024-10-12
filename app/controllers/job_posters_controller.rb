class JobPostersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_job_poster

  def applicants
    @jobs = current_user.jobs.includes(job_applications: :user)
  end

  private

  def ensure_job_poster
    unless current_user.job_poster?
      redirect_to root_path, alert: "You don't have permission to access this page."
    end
  end
end
