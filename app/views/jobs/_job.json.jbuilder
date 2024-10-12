json.extract! job, :id, :title, :description, :company, :location, :job_type, :salary, :apply_link, :created_at, :updated_at
json.url job_url(job, format: :json)
