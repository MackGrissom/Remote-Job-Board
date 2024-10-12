class JobsController < ApplicationController
  before_action :set_job, only: %i[ show destroy ]

  # GET /jobs or /jobs.json
  def index
    @jobs = Job.all
    
    respond_to do |format|
      format.html
      format.json {
        job_coordinates = @jobs.map do |job|
          {
            id: job.id,
            lat: job.latitude,
            lng: job.longitude,
            title: job.title,
            company: job.company,
            location: job.location,
            salary_min: job.salary_min,
            salary_max: job.salary_max,
            job_type: job.job_type,
            industry: job.industry,
            description: job.description,
            requirements: job.experience_level, # Assuming this is what you want for requirements
            apply_link: job.apply_link
          }
        end
        render json: {
          job_listings_html: render_to_string(partial: 'job_listings', locals: { jobs: @jobs }, formats: [:html]),
          job_coordinates: job_coordinates
        }
      }
    end
  end

  # GET /jobs/1 or /jobs/1.json
  def show
  end

  # GET /jobs/new
  def new
    @job = Job.new
  end

  # POST /jobs or /jobs.json
  def create
    @job = Job.new(job_params)

    respond_to do |format|
      if @job.save
        format.html { redirect_to @job, notice: "Job was successfully created." }
        format.json { render :show, status: :created, location: @job }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1 or /jobs/1.json
  def destroy
    @job.destroy!

    respond_to do |format|
      format.html { redirect_to jobs_path, status: :see_other, notice: "Job was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def job_params
      params.require(:job).permit(:title, :description, :company, :location, :job_type, :salary, :apply_link, :latitude, :longitude, :experience_level, :industry)
    end
end

  # Add these methods to handle salary_min and salary_max
  def salary_min
    salary.to_f
  end

  def salary_max
    salary.to_f
  end

  def salary_min
    salary.to_f
  end
