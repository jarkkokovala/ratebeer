module Top
  extend ActiveSupport::Concern

  def top(count)
    sorted_by_rating_in_desc_order = all.sort_by{ |x| -(x.average_rating || 0) }

    sorted_by_rating_in_desc_order[0..count - 1]
  end
end
