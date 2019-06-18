class Pokemon < ActiveRecord::Base
    belongs_to :user

    def self.losing_hp
        Pokemon.all.each do |pokemon|
            random = pokemon.hp - rand(1..5)
            pokemon.update(hp: random.clamp(1, 100))
        end
    end
end
