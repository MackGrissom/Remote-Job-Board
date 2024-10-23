require 'stripe'

class JobsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :check_job_posting_ability, only: [:new, :create]
  
  helper_method :industries
  helper_method :tech_industries

  # GET /jobs or /jobs.json
  def index
    @jobs = Job.all # Remove any pagination here

    if request.xhr?
      render json: {
        job_listings_html: render_to_string(partial: 'job_listings', locals: { jobs: @jobs }, formats: [:html]),
        job_coordinates: @jobs.map { |job| { id: job.id, lat: job.latitude, lng: job.longitude, title: job.title, company: job.company, location: job.location, salary_min: job.salary_min, salary_max: job.salary_max, job_type: job.job_type, industry: job.industry } }
      }
    else
      render 'index'
    end
  end

  # GET /jobs/1 or /jobs/1.json
  def show
    @job = Job.find(params[:id])
  end

  # GET /jobs/new
  def new
    @job = Job.new
    @countries = CityService.countries
    @regions = []
    @cities = []
  end

  # POST /jobs or /jobs.json
  def create
    @job = current_user.jobs.new(job_params)
    if @job.save
      current_user.decrement!(:job_posts_available)
      redirect_to @job, notice: 'Job was successfully created.'
    else
      @countries = CityService.countries
      @regions = CityService.regions(params[:job][:country]) if params[:job][:country].present?
      @cities = CityService.cities(params[:job][:country], params[:job][:region]) if params[:job][:country].present?
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

  def apply
    @job = Job.find(params[:id])
    if user_signed_in?
      redirect_to new_job_job_application_path(@job)
    else
      redirect_to new_user_session_path, alert: "Please log in or sign up to apply for this job."
    end
  end

  def my_jobs
    @applied_jobs = current_user.job_applications.includes(:job)
    @bookmarked_jobs = current_user.bookmarked_jobs
    @posted_jobs = current_user.jobs
  end

  def bookmark
    @job = Job.find(params[:id])
    current_user.bookmarked_jobs << @job unless current_user.bookmarked_jobs.include?(@job)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path, notice: 'Job bookmarked successfully.') }
      format.js
    end
  end

  def unbookmark
    @job = Job.find(params[:id])
    current_user.bookmarked_jobs.delete(@job)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path, notice: 'Job removed from bookmarks.') }
      format.js
    end
  end

  def filter
    @jobs = Job.all

    if params[:filters].present?
      params[:filters].each do |key, values|
        @jobs = @jobs.where(key => values)
      end
    end

    if params[:sort_by].present?
      case params[:sort_by]
      when 'most-recent'
        @jobs = @jobs.order(created_at: :desc)
      when 'salary-high-to-low'
        @jobs = @jobs.order(salary_max: :desc)
      when 'salary-low-to-high'
        @jobs = @jobs.order(salary_min: :asc)
      when 'salary'
        @jobs = @jobs.order(salary: :desc)
      end
    end

    render json: {
      job_listings_html: render_to_string(partial: 'job_listings', locals: { jobs: @jobs }, formats: [:html])
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def job_params
      params.require(:job).permit(:title, :company, :description, :job_type, :country, :location,
                                :experience_level, :salary, :industry)
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

    def industries
      {
        'Accounting': '📊', 'Advertising': '📢', 'Aerospace': '✈️',
        'Agriculture': '🌾', 'Automotive': '🚗', 'Banking': '🏦',
        'Biotechnology': '🧬', 'Broadcasting': '📺', 'Business Services': '💼',
        'Chemicals': '⚗️', 'Communications': '📡', 'Construction': '🏗️',
        'Consulting': '🗣️', 'Consumer Products': '🛍️', 'Education': '🎓',
        'Electronics': '🔌', 'Energy': '⚡', 'Engineering': '🛠️',
        'Entertainment': '🎬', 'Environmental': '🌿', 'Fashion': '👗',
        'Finance': '💰', 'Food and Beverage': '🍽️', 'Government': '🏛️',
        'Healthcare': '🏥', 'Hospitality': '🏨', 'Insurance': '🛡️',
        'Legal': '️', 'Logistics': '🚚', 'Manufacturing': '🏭',
        'Marketing': '📈', 'Media': '📰', 'Mining': '⛏️',
        'Non-Profit': '🤝', 'Pharmaceuticals': '💊', 'Public Relations': '🗞️',
        'Publishing': '📚', 'Real Estate': '🏠', 'Retail': '🛒',
        'Software': '💻', 'Sports': '⚽', 'Technology': '🔧',
        'Telecommunications': '📞', 'Transportation': '🚆', 'Travel': '✈️'
      }
    end

    def check_job_posting_ability
      unless current_user&.respond_to?(:can_post_job?) && current_user&.can_post_job?
        redirect_to new_payment_path, alert: "You need to purchase a job posting package to post a job."
      end
    end

    def tech_industries
      {
        'Software Development': '',
        'Data Science': '📊',
        'Cybersecurity': '🔒',
        'AI/Machine Learning': '🤖',
        'Cloud Computing': '☁️',
        'DevOps': '🛠️',
        'UX/UI Design': '🎨',
        'Web Development': '🌐',
        'Mobile Development': '📱',
        'Network Engineering': '🌐',
        'IT Support': '🖥️',
        'Database Administration': '🗄️'
      }
    end

    def continents
      {
        'north_america': 'North America',
        'south_america': 'South America',
        'europe': 'Europe',
        'asia': 'Asia',
        'africa': 'Africa',
        'australia': 'Australia'
      }
    end

    def experience_levels
      {
        'entry': 'Entry Level',
        'mid': 'Mid Level',
        'senior': 'Senior Level'
      }
    end
end
