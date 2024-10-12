class JobApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_job

  def new
    @job_application = @job.job_applications.build
  end

  def create
    @job_application = @job.job_applications.build(job_application_params)
    @job_application.user = current_user

    if @job_application.save
      render json: { message: 'Application submitted successfully' }, status: :created
    else
      render json: { errors: @job_application.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_job
    @job = Job.find(params[:job_id])
  end

  def job_application_params
    params.require(:job_application).permit(:cover_letter)
  end
end
