module JobsHelper
  def formatSalary(min, max)
    "#{(min / 1000).round}k-#{(max / 1000).round}k"
  end

  def industry_emoji(industry)
    case industry
    when 'Technology'
      '💻'
    when 'Healthcare'
      '🏥'
    when 'Finance'
      '💰'
    when 'Education'
      '🎓'
    when 'Retail'
      '🛍️'
    else
      '🏢'
    end
  end

  def industry_options_with_emoji
    [
      ['💻 Technology', 'Technology'],
      ['🏥 Healthcare', 'Healthcare'],
      ['💰 Finance', 'Finance'],
      ['🎓 Education', 'Education'],
      ['🛍️ Retail', 'Retail']
    ]
  end
end
