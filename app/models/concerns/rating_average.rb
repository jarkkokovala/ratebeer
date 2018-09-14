module RatingAverage
    extend ActiveSupport::Concern
   
    def average_rating
        r = ratings.pluck(:score)
        if r.length != 0
            r.sum / r.length
        end
    end
end