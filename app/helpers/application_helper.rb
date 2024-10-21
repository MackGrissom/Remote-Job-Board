module ApplicationHelper
  # ... other helper methods ...

  def country_flag_emoji(country_code)
    country_code.upcase.chars.map { |c| (c.ord + 127397).chr(Encoding::UTF_8) }.join
  end
end
