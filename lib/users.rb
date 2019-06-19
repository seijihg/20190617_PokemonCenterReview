class User < ActiveRecord::Base
    has_many :reviews
    has_many :centers, through: :reviews
    has_one :pokemon

    def heal_pokemon(center_id)
        center = Center.all.select {|c| c.id == center_id}
        poke = Pokemon.find_by(name: self.pokemon.name)
        origin_hp = poke.hp
        after_hp = (poke.hp += rand(5..20)).clamp(1, 100)
        amount = after_hp - origin_hp
        self.pokemon.hp = after_hp
        sleep 1
        puts "Great your #{poke.name} has healed by #{amount}"
        poke.save
    end

    def pokemon_hp
        poke = Pokemon.find(self.pokemon.id)
        poke.hp
    end

    def check_hp
        if pokemon_hp < 50
            puts "Your Pokemon HP is #{pokemon_hp}! Go to Pokemon Center straight away!"
        elsif pokemon_hp == 0
            puts "Your Pokemon has died, MURDERER!"
            sleep 3
            exit
        else puts "Your #{self.pokemon.name.capitalize} has #{pokemon_hp} HP and is healthy!"
        end
    end

    def add_review(content:, center_id:, rating:)
        Review.create(user_id: self.id, content: content, center_id: center_id, rating: rating.clamp(1, 5))
    end

    def user_reviews
        Review.all.select {|rev| rev.user == self}
    end

end
