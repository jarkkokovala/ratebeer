class RatingsController < ApplicationController
  def index
    Rails.cache.write("Recent ratings", Rating.recent, expires_in: 10.minutes) if !Rails.cache.exist?("Recent ratings")
    @recent_ratings = Rails.cache.read "Recent ratings", race_condition_ttl: 15.seconds
    Rails.cache.write("Top beers", Beer.top(3), expires_in: 10.minutes) if !Rails.cache.exist?("Top beers")
    @beers = Rails.cache.read "Top beers", race_condition_ttl: 15.seconds
    Rails.cache.write("Top styles", Style.top(3), expires_in: 10.minutes) if !Rails.cache.exist?("Top styles")
    @styles = Rails.cache.read "Top styles", race_condition_ttl: 15.seconds
    Rails.cache.write("Top breweries", Brewery.top(3), expires_in: 10.minutes) if !Rails.cache.exist?("Top breweries")
    @breweries = Rails.cache.read "Top breweries", race_condition_ttl: 15.seconds
    Rails.cache.write("Top users", User.top(3), expires_in: 10.minutes) if !Rails.cache.exist?("Top users")
    @users = Rails.cache.read "Top users", race_condition_ttl: 15.seconds
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user

    if @rating.save
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user

    redirect_to user_path(current_user)
  end
end
