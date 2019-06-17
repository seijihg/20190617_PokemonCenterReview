def your_data

    puts "Welcome to the Pokemon World! What is your name?"
    us_name = get_name
    puts "This is great #{us_name.capitalize}. How old are you?"
    us_age = get_age
    puts "Hmmm #{us_age}. Let me assign a Pokemon to you to start your journey!"
    po_poke = random_pokemon.name
    puts "Puff!! ... open a pokeball! Your Pokemon is #{po_poke.capitalize}"
    puts "Now #{us_name} and #{po_poke.capitalize} start the journey together"
    po_type = find_out_type(po_poke).downcase

    us1 = User.create(name: us_name, age: us_age)
    po1 = Pokemon.create(name: po_poke, pokemon_type: po_type, hp: random_hp)

    us1.pokemon = po1

    if po1.hp < 50
        puts "Your #{po_poke} needs to go to the Pokemon Center to heal up!"
    else puts "Pick the following options: "
    end

end
