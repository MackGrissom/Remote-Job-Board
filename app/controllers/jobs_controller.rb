class JobsController < ApplicationController
  # If you want to allow non-authenticated users to view the index, uncomment the next line
  # skip_before_action :authenticate_user!, only: [:index]

  # GET /jobs or /jobs.json
  def index
    @jobs = Job.all
    respond_to do |format|
      format.html
      format.json { 
        render json: { 
          job_listings_html: render_to_string(partial: 'job_listings', locals: { jobs: @jobs }, formats: [:html]),
          job_coordinates: @jobs.map { |job| { lat: job.latitude, lng: job.longitude, title: job.title, company: job.company, location: job.location, salary_min: job.salary_min, salary_max: job.salary_max, job_type: job.job_type, industry: job.industry, id: job.id } }
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
        # Process successful payment and job creation
        format.html { redirect_to @job, notice: 'Job was successfully posted.' }
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

    def create_payment_intent
      amount = params[:posting_type] == 'featured' ? 49900 : 29900 # Amount in cents
      payment_intent = Stripe::PaymentIntent.create(
        amount: amount,
        currency: 'usd',
        automatic_payment_methods: { enabled: true }
      )
      render json: { clientSecret: payment_intent.client_secret }
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
