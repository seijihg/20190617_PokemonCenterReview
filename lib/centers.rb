class Center < ActiveRecord::Base
    has_many :reviews
    has_many :users, through: :reviews


    def reviews
        Review.all.select {|review| review.center == self}
    end

    def average_rating
        avg = reviews.sum {|rev| rev.rating} / reviews.count.to_f
        avg.round(1)
    end

    def average_ratings
        Center.all.sort_by {|center| center.average_rating}
    end

    def show_ranking
        ["Center: #{self.center}",
        "Center Type: #{self.center_type}",
        "Average Rating: #{self.average_rating}"]
    end

end
