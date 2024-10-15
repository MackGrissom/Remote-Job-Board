class JobApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_job

  def new
    @job_application = @job.job_applications.build
  end

  def my_applications
    @applications = current_user.job_applications.includes(:job)
  end

  def index
    @applications = @job.job_applications
  end

  def create
    @job = Job.find(params[:job_id])
    @job_application = @job.job_applications.new(job_application_params)
    @job_application.user = current_user

    if @job_application.save
      redirect_to @job, notice: 'Application submitted successfully.'
    else
      render :new
    end
  end

  private

  def set_job
    @job = Job.find(params[:job_id])
  end

  def job_application_params
    params.require(:job_application).permit(:full_name, :email, :phone, :linkedin_url, :resume, :cover_letter)
  end
end
