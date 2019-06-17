class User < ActiveRecord::Base
    has_many :reviews
    has_many :centers, through: :reviews
    has_one :pokemon

    def heal_pokemon(center_id)
        center = Center.all.select {|c| c.id == center_id}
        player = Pokemon.find_by(name: self.pokemon.name)
        player.hp += rand(5..20)
        player.save
    end
end