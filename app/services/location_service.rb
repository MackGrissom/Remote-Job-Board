class LocationService
  def self.countries
    CS.countries.map { |k, v| [v, k] }
  end

  def self.states(country_code)
    CS.states(country_code).map { |k, v| [v, k] }
  end

  def self.cities(country_code, state_code)
    CS.cities(state_code, country_code) || []
  end
end
