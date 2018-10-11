class User < ApplicationRecord
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beerclubs, through: :memberships

  has_secure_password

  validates :username, uniqueness: true, length: { minimum: 3, maximum: 30 }

  PASSWORD_FORMAT = /\A
  (?=.{4,})          # Must contain 4 or more characters
  (?=.*\d)           # Must contain a digit
  (?=.*[A-Z])        # Must contain an upper case character
  /x

  validates :password, format: { with: PASSWORD_FORMAT }

  include RatingAverage

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    style_id = ratings.joins(:beer).group('beers.style_id').average('score').sort_by { |a| a[1] }.reverse.first[0]
    Style.find_by(id: style_id)
  end

  def favorite_brewery
    return nil if ratings.empty?

    brewery_id = ratings.joins(:beer).group('beers.brewery_id').average('score').sort_by { |a| a[1] }.reverse.first[0]

    Brewery.find_by(id: brewery_id)
  end

  def self.top(count)
    sorted_by_rating_count_in_desc_order = User.all.sort_by{ |u| -(u.ratings.count || 0) }

    sorted_by_rating_count_in_desc_order[0..count - 1]
  end
end
