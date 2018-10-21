class Style < ApplicationRecord
  has_many :beers
  has_many :ratings, through: :beers

  include RatingAverage
  extend Top

  def to_s
    name
  end
end
