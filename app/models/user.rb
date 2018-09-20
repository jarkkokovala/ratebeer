class User < ApplicationRecord
  has_many :ratings
  has_many :beers, through: :ratings
  has_many :memberships
  has_many :beerclubs, through: :memberships

  validates :username, uniqueness: true, length: { minimum: 3, maximum: 30 }

  include RatingAverage
end
