$prompt = TTY::Prompt.new
$cliuser = nil

def welcome
    puts "Welcome to the Pokecenter Review app"

    option = $prompt.select('Login or Register', ['Login', 'Register', 'Exit'])
        if option == "Login"
            login =$prompt.collect do
                key(:name).ask('What is your name?') do |u|
                u.modify :down
                end
            end

            if User.exists?(name: login[:name])
                $cliuser = User.find_by(name: login[:name])
                puts 'Success. Welcome'
                sleep 1
                $cliuser.check_hp
                sleep 1
                main_menu
            elsif login[:name] == nil
               $prompt.error('Please enter a valid username')
                welcome
            else
               $prompt.error('Please enter a valid username')
                welcome
            end
        elsif option == 'Register'
            new_name = $prompt.collect do
                            key(:name).ask('What is your name?') do |u|
                                u.modify :down
                            end
                        end

                        if User.exists?(name: new_name[:name])
                           $prompt.error('Name already taken, please select another')
                            welcome
                        elsif new_name[:name] == nil
                           $prompt.error('Please enter a valid username')
                            welcome
                        else
                            new_age = $prompt.collect do
                                            key(:age).ask('What is your age?') do |an|
                                                an.validate /[0-9]/
                                            end
                                        end
                        end

                            $cliuser = User.create(name: new_name[:name], age: new_age[:age])
                            add_pokemon_to_user
                            $cliuser.check_hp
        else option == 'Exit'
            exit
        end

end


def add_pokemon_to_user
    $prompt.say('Lets pick a pokemon')
    # pokemon_list = (Pokemon.all.map {|pokemon| pokemon.name.capitalize}).sample(3)
    poke_list = PokeApi.get(:pokemon).results.sample(3)
    pokemon_list = poke_list.map {|pokemon| pokemon.name.capitalize}

    pokemon = $prompt.select('Please select a Pokemon', [pokemon_list, 'Lucky Dip'])
        if pokemon == 'Lucky Dip'
            selected_pokemon = random_pokemon
        else 
            Pokemon.create(name: pokemon.downcase, pokemon_type: find_out_type(pokemon.downcase), hp: random_hp)
            selected_pokemon = Pokemon.all.find_by(name: pokemon.downcase)
        end
    add = $prompt.select("Add #{selected_pokemon.name.capitalize} to #{$cliuser.name}?", ['Yes', 'No'])
        if add == 'Yes'
            $cliuser.pokemon = selected_pokemon
            $prompt.ok("Congratulations, here’s your #{selected_pokemon.name.capitalize}")
            main_menu
        else add == 'No'
            add_pokemon_to_user
        end
end

def main_menu
    Pokemon.losing_hp
    option = $prompt.select('Main Menu', ['Visit Pokemon Center', 'See all Reviews', 'Pokemon Center Ranking', 'Log out'])
        if option == 'Visit Pokemon Center'
            visit_center
        elsif option == 'See all Reviews'
            see_all_reviews
            sleep 1
        elsif option == 'Pokemon Center Ranking'
            pokecenter_rank
            sleep 1
        else option == 'Log out'
            welcome
        end
end

def visit_center
    Pokemon.losing_hp
    center_list = (Center.all.map {|pc| pc.center})
    pokecenter = $prompt.select("Which Pokemon Center do you want to visit?", center_list, per_page: 20)
    $selected_center = Center.all.find_by(center: pokecenter)
    pokecenter_menu
end

def see_all_reviews

    Review.all.map {|rev| rev.show_review}
    $prompt.select('Back')
    main_menu
end

def pokecenter_rank
    center_with_reviews.sort_by {|center| center.average_rating}
    $prompt.select('Back')
    main_menu
end

def pokecenter_menu
    Pokemon.losing_hp
    $cliuser.check_hp
    pc_menu = $prompt.select("Welcome to the #{$selected_center.center} Pokemon Center Menu", ['Heal Pokemon', 'See Center Reviews', 'Edit Reviews', 'Delete Review', 'Leave Center'])
        if pc_menu == 'Heal Pokemon'
            sleep 1
            $cliuser.heal_pokemon($selected_center.id)
            user_hash = collect_for_review
            $cliuser.add_review(content: user_hash[:content], rating: user_hash[:rating].to_i, center_id: $selected_center.id)
            
            pokecenter_menu
            binding.pry
        elsif pc_menu == 'See Center Reviews'
            center_reviews
            sleep 1
        elsif pc_menu == 'Edit a Review'
            edit_review
            sleep 1
        elsif pc_menu == 'Delete a Review'
            delete_review
            sleep 1
        else pc_menu == 'Leave Center'
            main_menu
        end
end

def collect_for_review
    $prompt.collect do
        key(:content).ask('How was the experience you had with us?')
        key(:rating).ask("How do you score us between 1 and 5?", validate: /1-5/)
    end
end

def select_review
    review_list = user_reviews.map {|rev| rev.center == $selected_center}
    review = $prompt.select('Please select a Review', [review_list])
    $selected_review = Review.all.find_by(id: review.id)
end

def edit_review
    select_review
    edit = $prompt.select("Edit #{$selected_review}?", ["Yes", "No"])
        if edit == "Yes"
            puts "Please write a new review"
            $selected_review.content = gets.chomp
            $selected_review.save
            puts "Please give a new rating"
            $selected_review.rating = gets.chomp
            $selected_review.save
            $prompt.ok("Done.")
            pokecenter_menu
        else edit == "No"
            pokecenter_menu
        end
end

def delete_review
    select_review
    delete = $prompt.select("Delete #{$selected_review}?", ["Yes", "No"])
        if delete == "Yes"
            Review.all.where(id: $selected_review.id).destroy_all
            $selected_review = ''
            $prompt.ok("Done.")
            pokecenter_menu
        else delete == "No"
            pokecenter_menu
        end
end

