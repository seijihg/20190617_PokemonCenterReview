class Center < ActiveRecord::Base
    has_many :reviews
    has_many :users, through: :reviews


    def reviews
        Review.all.select {|review| review.center == self}
    end

    def average_rating
        reviews.sum {|rev| rev.rating} / reviews.count.to_f
    end

end
