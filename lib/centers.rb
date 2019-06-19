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

    def self.average_ratings
        centers_with_review = Center.all.select {|rev| !rev.reviews.empty?}
        centers_with_review.sort_by {|center| center.average_rating}
    end

    def show_ranking
        [Rainbow("Center: #{self.center}").red,
        Rainbow("Center Type: #{self.center_type.capitalize}").white,
        Rainbow("Average Rating: #{self.average_rating}").blue]
    end

end
