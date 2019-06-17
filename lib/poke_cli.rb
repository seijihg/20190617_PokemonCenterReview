def your_data
    puts "Welcome to the Pokemon World! What is your name?"
    name = get_name
    puts "This is great #{name.capitalize}. How old are you?"
    age = get_age
    puts "Hmmm #{age}. Let me assign a Pokemon to you to start your journey!"
    poke = random_pokemon.name
    puts "Puff!! ... open a pokeball! Your Pokemon is #{poke.capitalize}"
    puts "Now #{name} and #{poke.capitalize} start the journey together"
end
