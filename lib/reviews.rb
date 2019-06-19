class Review < ActiveRecord::Base
    belongs_to :user
    belongs_to :center

    def show_review
        ["Center: #{self.center.center}",
        "Review: #{self.content}",
        "Rating: #{self.rating}",
        "User: #{self.user.name.capitalize}"]
    end
    
end