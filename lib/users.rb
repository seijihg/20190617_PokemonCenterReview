class User < ActiveRecord::Base
    has_many :reviews
    has_many :centers, through: :reviews
    has_one :pokemon

    def heal_helper(value)
        poke = Pokemon.find_by(name: self.pokemon.name)
        origin_hp = poke.hp
        after_hp = (poke.hp += value).clamp(0, 100)
        amount = after_hp - origin_hp
        self.pokemon.hp = after_hp
        sleep 1
        puts "Great your #{poke.name} has healed by #{amount}."
        poke.save
    end

    def heal_pokemon(center_id)
        center = Center.all.select {|c| c.id == center_id}
        poke = Pokemon.find_by(name: self.pokemon.name)
        if poke.pokemon_type == center.last.center_type
            puts Rainbow("Our speciality is #{center.last.center_type} and your pokemon is the same type! We shall heal you double the normal amount!!").red.blink
            heal_helper(rand(20..40))
        else
            heal_helper(rand(5..20))
        end
        $cliuser.show_hp
    end

    def pokemon_hp
        poke = Pokemon.find(self.pokemon.id)
        poke.hp
    end

    def check_hp
        if pokemon_hp < 1
            puts Rainbow("Your Pokemon has died, MURDERER!").red.blink
            play_scream
            sleep 3
            visit_center
        elsif pokemon_hp < 50
            puts "Your #{self.pokemon.name.capitalize} HP is #{pokemon_hp}! Go to Pokemon Center straight away!"
        else
            puts Rainbow("Your #{self.pokemon.name.capitalize} has #{pokemon_hp} HP and is healthy!").green
        end
    end

    def show_hp
        puts Rainbow("Your Pokemon HP is now #{pokemon_hp}.").cyan.blink
    end

    def add_review(content:, center_id:, rating:)
        Review.create(user_id: self.id, content: content, center_id: center_id, rating: rating.clamp(1, 5))
    end

    def user_reviews
        Review.all.select {|rev| rev.user == self}
    end

end



