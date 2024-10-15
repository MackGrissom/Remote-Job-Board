require 'stripe'

class JobsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  
  # GET /jobs or /jobs.json
  def index
    @jobs = Job.all

    if params[:location].present? && params[:location] != 'All Locations'
      @jobs = filter_by_continent(@jobs, params[:location])
    end

    @jobs = @jobs.where(industry: params[:industry]) if params[:industry].present? && params[:industry] != 'All Industries'

    job_types = []
    job_types << 'Full-time' if params[:job_type_full_time] == '1'
    job_types << 'Part-time' if params[:job_type_part_time] == '1'
    job_types << 'Contract' if params[:job_type_contract] == '1'
    @jobs = @jobs.where(job_type: job_types) if job_types.any?

    case params[:salary_range]
    when '0-50000'
      @jobs = @jobs.where('salary_min <= ? OR salary_max <= ?', 50000, 50000)
    when '50001-100000'
      @jobs = @jobs.where('(salary_min BETWEEN ? AND ?) OR (salary_max BETWEEN ? AND ?)', 50001, 100000, 50001, 100000)
    when '100001+'
      @jobs = @jobs.where('salary_min >= ? OR salary_max >= ?', 100001, 100001)
    end

    respond_to do |format|
      format.html
      format.json do
        render json: {
          job_listings_html: render_to_string(partial: 'job_listings', locals: { jobs: @jobs }, formats: [:html]),
          job_coordinates: @jobs.map { |job| { id: job.id, lat: job.latitude, lng: job.longitude, title: job.title, company: job.company, location: job.location, salary_min: job.salary_min, salary_max: job.salary_max, job_type: job.job_type, industry: job.industry, apply_link: job.apply_link } }
        }
      end
    end
  end

  # GET /jobs/1 or /jobs/1.json
  def show
    @job = Job.find(params[:id])
    @applications = @job.job_applications.includes(:user) if current_user == @job.user
  end

  # GET /jobs/new
  def new
    puts "Stripe API Key: #{Stripe.api_key}"  # Add this line
    @job = Job.new
    @payment_intent = create_payment_intent
  end

  # POST /jobs or /jobs.json
  def create
    @job = Job.new(job_params)
    
    if @job.save
      redirect_to @job, notice: 'Job was successfully created.'
    else
      render :new
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
      params.require(:job).permit(
        :title, :company, :description, :job_type, :location,
        :experience_level, :salary_min, :salary_max, :industry
      )
    end

    def create_payment_intent
      ::Stripe::PaymentIntent.create({
        amount: job_posting_price,
        currency: 'usd',
        payment_method_types: ['card'],
      })
    end

    def filter_by_continent(jobs, continent)
      case continent
      when 'North America'
        jobs.where("location LIKE ?", "%United States%")
          .or(jobs.where("location LIKE ?", "%Canada%"))
          .or(jobs.where("location LIKE ?", "%Mexico%"))
      when 'South America'
        jobs.where("location LIKE ?", "%Brazil%")
          .or(jobs.where("location LIKE ?", "%Argentina%"))
          .or(jobs.where("location LIKE ?", "%Colombia%"))
          .or(jobs.where("location LIKE ?", "%Peru%"))
      when 'Europe'
        jobs.where("location LIKE ?", "%United Kingdom%")
          .or(jobs.where("location LIKE ?", "%Germany%"))
          .or(jobs.where("location LIKE ?", "%France%"))
          .or(jobs.where("location LIKE ?", "%Italy%"))
          .or(jobs.where("location LIKE ?", "%Spain%"))
      when 'Asia'
        jobs.where("location LIKE ?", "%China%")
          .or(jobs.where("location LIKE ?", "%Japan%"))
          .or(jobs.where("location LIKE ?", "%India%"))
          .or(jobs.where("location LIKE ?", "%Singapore%"))
      when 'Africa'
        jobs.where("location LIKE ?", "%South Africa%")
          .or(jobs.where("location LIKE ?", "%Nigeria%"))
          .or(jobs.where("location LIKE ?", "%Kenya%"))
          .or(jobs.where("location LIKE ?", "%Egypt%"))
      when 'Australia'
        jobs.where("location LIKE ?", "%Australia%")
          .or(jobs.where("location LIKE ?", "%New Zealand%"))
      else
        jobs
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

    def job_posting_price
      params[:posting_type] == 'featured' ? 49900 : 29900
    end
end
