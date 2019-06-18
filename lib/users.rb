class User < ActiveRecord::Base
    has_many :reviews
    has_many :centers, through: :reviews
    has_one :pokemon

    def heal_pokemon(center_id)
        center = Center.all.select {|c| c.id == center_id}
        poke = Pokemon.find_by(name: self.pokemon.name)
        origin_hp = poke.hp
        after_hp = poke.hp += rand(5..20)
        poke.save
        amount = origin_hp - after_hp
        sleep 2
        puts "Great your #{poke.name} has healed by #{amount}"
    end

    def pokemon_hp
        self.pokemon.hp
    end

    def check_hp
        if pokemon_hp < 50
            puts "Your Pokemon HP is #{pokemon_hp}! Go to Pokemon Center straight away!"
        else puts "Your #{self.pokemon.name.capitalize} has #{pokemon_hp} and is healthy!"
        end
    end

    def add_review(content:, center_id:, rating:)
        Review.create(user_id: self.id, content: content, center_id: center_id, rating: rating.clamp(1, 5))
    end

    def user_reviews
        Review.all.select {|rev| rev.user == self}
    end

end