# This controller can be removed if it's not used for other purposes
class LocationsController < ApplicationController
  def states
    render json: CS.states(params[:country]).map { |k, v| [v, k] }
  end

  def regions
    render json: CityService.regions(params[:country])
  end

  def cities
    render json: CityService.cities(params[:country], params[:region])
  end
end
