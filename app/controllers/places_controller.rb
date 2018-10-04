class PlacesController < ApplicationController
  before_action :set_place, only: [:show]

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

  def set_place
    @place = BeermappingApi.places_in(session[:city]).find { |place| place["id"] == params[:id] }
  end
end
