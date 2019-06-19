class Review < ActiveRecord::Base
    belongs_to :user
    belongs_to :center

    def show_review
        [Rainbow("Center: #{self.center.center}").green,
        Rainbow("Review: #{self.content}").yellow,
        Rainbow("Rating: #{self.rating}").red,
        Rainbow("User: #{self.user.name.capitalize}").blue]
    end
    
    def show_selected_review
        ["Review: #{self.content}, Rating: #{self.rating}, id: #{self.id}"]
    end
end