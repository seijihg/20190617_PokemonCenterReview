class Pokemon < ActiveRecord::Base
    belongs_to :user
end

def find_out_type(pokemon_name)
    PokeApi.get(pokemon: pokemon_name).types.first.type.name.capitalize
end