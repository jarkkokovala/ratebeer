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
end
