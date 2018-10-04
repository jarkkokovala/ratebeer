class PlacesController < ApplicationController
  before_action :set_place, only: [:show]
  before_action :set_weather, only: [:index, :search]

  def index
  end

  def search
    session[:city] = params[:city]
    @places = BeermappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end

  def show
  end

  def set_weather
    @weather = ApixuApi.weather_in("helsinki")
  end

  def set_place
    @place = BeermappingApi.places_in(session[:city]).find { |place| place["id"] == params[:id] }
  end
end
