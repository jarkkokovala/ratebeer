class Beer < ApplicationRecord
  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  validates :name, length: { minimum: 1 }
  validates :style, length:  { minimum: 1 }

  include RatingAverage

  def to_s
    name + " (" + brewery.name + ")"
  end
end
