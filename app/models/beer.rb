class Beer < ApplicationRecord
  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  validates :name, length: { minimum: 1 }

  include RatingAverage

  def self.top(count)
    sorted_by_rating_in_desc_order = Beer.all.sort_by{ |b| -(b.average_rating || 0) }

    sorted_by_rating_in_desc_order[0..count - 1]
  end

  def to_s
    name + " (" + brewery.name + ")"
  end
end
