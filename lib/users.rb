def get_name
    user_name = gets.chomp
    while user_name.empty?
        puts "Your name please?"
        user_name = gets.chomp
    end
    user_name.downcase
end

def get_age
    user_age = gets.chomp
    while user_age.empty? || user_age.to_i == 0
        puts "Your age please and in a number?"
        user_age = gets.chomp
    end
    user_age.to_i.clamp(10, 99)
end

def random_pokemon
    pokemons = PokeApi.get(:pokemon)
    pokemon = pokemons.results.sample
end

class Users < ActiveRecord::Base
    has_many :reviews
    has_many :centers, through: :reviews
    has_one :pokemons
end