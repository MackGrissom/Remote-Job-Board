module JobsHelper
  def formatSalary(min, max)
    "#{(min / 1000).round}k-#{(max / 1000).round}k"
  end
end
