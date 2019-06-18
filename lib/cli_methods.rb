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
    Pokemon.create(name: pokemon.name, pokemon_type: find_out_type(pokemon.name), hp: random_hp)
end

def random_three_pokemon
    pokemons = PokeApi.get(:pokemon)
    pokemon = pokemons.results.sample(3)
    binding.pry
    Pokemon.create(name: pokemon.name, pokemon_type: find_out_type(pokemon.name), hp: random_hp)
end

def find_out_type(pokemon_name)
    PokeApi.get(pokemon: pokemon_name).types.first.type.name
end

def random_hp
    rand(1..100)
end

def centers_db
    PokeApi.get(location: {offset: rand(1..781)}).results.select {|city| city.name.include?("city")}.map {|city| city.name.capitalize}
end

def add_centers_to_db
    centers_db.each {|center| Center.create(center: center, center_type: random_type_for_poke_center)}
end

def random_type_for_poke_center
    PokeApi.get(:type).results.map {|type| type.name}.sample
end

def center_with_reviews
    Center.all.select {|center| !center.reviews.empty?}
end

def center_reviews
    center_revs = Review.all.select {|review| review.center == selected_center}
    if center_revs.empty?
        puts "There are no reviews yet for this Center"
    end
end