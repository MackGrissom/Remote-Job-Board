require 'countries'

class CityService
  def self.countries
    ISO3166::Country.all.map { |country| [country.iso_short_name, country.alpha2] }
  end

  def self.regions(country_code)
    country = ISO3166::Country[country_code]
    country.subdivisions.map { |code, subdivision| [subdivision.name, code] }
  end

  def self.cities(country_code, region_code = nil)
    # Unfortunately, the countries gem doesn't provide city data
    # You might need to use a separate data source for cities
    []
  end
end
