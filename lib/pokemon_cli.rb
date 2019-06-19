$prompt = TTY::Prompt.new
$cliuser = nil

def systemclear(pagetitle)
  system "clear"
  puts "\n\n"
  puts Rainbow("                                .::.").red.blink
  puts Rainbow("                              .;:**'").red.blink
  puts Rainbow("                              `").red.blink
  puts Rainbow("  .:XHHHHk.              db.   .;;.     dH  MX").red
  puts Rainbow("oMMMMMMMMMMM       ~MM  dMMP :MMMMMR   MMM  MR      ~MRMN").red
  puts Rainbow("QMMMMMb  'MMX       MMMMMMP !MX' :M~   MMM MMM  .oo. XMMM 'MMM").red
  puts Rainbow("  `MMMM.  )M> :X!Hk. MMMM   XMM.o'  .  MMMMMMM X?XMMM MMM>!MMP").red
  puts Rainbow("   'MMMb.dM! XM M'?M MMMMMX.`MMMMMMMM~ MM MMM XM `' MX MMXXMM").red
  puts Rainbow("    ~MMMMM~ XMM. .XM XM`'MMMb.~*?**~ .MMX M t MMbooMM XMMMMMP").white
  puts Rainbow("     ?MMM>  YMMMMMM! MM   `?MMRb.    `'''   !L'MMMMM XM IMMM").white
  puts Rainbow("      MMMX   'MMMM'  MM       ~%:           !Mh.''' dMI IMMP").white
  puts Rainbow("      'MMM.                                             IMX").white
  puts Rainbow("       ~M!M            'Gotta heal'em all'              IMP").white
  puts Rainbow(" ============================================================").white
  puts Rainbow(" #{pagetitle} ").white.center(72)
  puts Rainbow(" ============================================================").white
  puts "\n\n"
end

def welcome
    systemclear("Welcome to our Pokemon Center Review app")

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
            system("killall afplay")
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
            $prompt.ok("Congratulations, here’s your #{selected_pokemon.name.capitalize}, #{selected_pokemon.hp} HP.")
            main_menu
        else add == 'No'
            add_pokemon_to_user
        end
end

def main_menu
    systemclear("MAIN MENU")
    Pokemon.losing_hp
    $cliuser.check_hp
    option = $prompt.select('Main Menu', ['Visit Pokemon Center', 'See all Reviews', 'Pokemon Center Ranking', 'Look for More Pokemon Centers!', 'Log out'])
        if option == 'Visit Pokemon Center'
            visit_center
        elsif option == 'See all Reviews'
            see_all_reviews
            sleep 1
        elsif option == 'Pokemon Center Ranking'
            pokecenter_rank
            sleep 1
        elsif option == 'Look for More Pokemon Centers!'
            puts "#{$cliuser.name.capitalize} travel far beyond the existing border to find more Centers!"
            sleep 2
            puts Rainbow("...").blink
            sleep 1
            new_center = add_centers_to_db
            if new_center.empty?
                puts "No Luck finding anything"
                sleep 2
                main_menu
            else 
                puts "Great we found #{new_center.size} new centers:"
                sleep 1
                new_center.each {|c| puts c}
                sleep 2
                main_menu
            end

        else option == 'Log out'
            welcome
        end
end

def visit_center
    center_list = (Center.all.map {|pc| pc.center})
    pokecenter = $prompt.select("Which Pokemon Center do you want to visit?", center_list, per_page: 20)
    $selected_center = Center.all.find_by(center: pokecenter)
    pokecenter_menu
end

def see_all_reviews
    systemclear("ALL REVIEWS")
    Pokemon.losing_hp
    $cliuser.check_hp
    Review.all.map {|rev| rev.show_review}.each {|r| puts r}
    $prompt.keypress("Press space or enter to go back", keys: [:space, :return])
    main_menu
end

def pokecenter_rank
    systemclear("RANKINGS")
    Pokemon.losing_hp
    $cliuser.check_hp
    rank = Center.average_ratings.reverse
    rank.map {|center| center.show_ranking}.each {|r| puts r}
    $prompt.keypress("Press space or enter to go back", keys: [:space, :return])
    main_menu
end

def pokecenter_menu
    systemclear("Welcome to #{$selected_center.center} Pokemon Center")
    play_pokecenter_music
    
    pc_menu = $prompt.select("Welcome to the #{$selected_center.center} Pokemon Center Menu", ['Heal Pokemon', 'See Center Reviews', 'Edit Review', 'Delete Review', 'Leave Center'])
        if pc_menu == 'Heal Pokemon'
            sleep 1
            $cliuser.heal_pokemon($selected_center.id)
            user_hash = collect_for_review
            $cliuser.add_review(content: user_hash[:content], rating: user_hash[:rating].to_i, center_id: $selected_center.id)
            $cliuser.check_hp
            pokecenter_menu
        elsif pc_menu == 'See Center Reviews'
            center_reviews
            sleep 1
        elsif pc_menu == 'Edit Review'
            edit_review
            sleep 1
        elsif pc_menu == 'Delete Review'
            delete_review
            sleep 1
        else pc_menu == 'Leave Center'
            play_opening_music
            main_menu
        end
end

def collect_for_review
    $prompt.collect do
        key(:content).ask('How was the experience you had with us?') do |re|
            re.validate(/./, "Please enter a review")
        end
        key(:rating).ask("How do you score us between 1 and 5?") do |ra|
            ra.validate(/[1-5]/, "Please enter a rating between 1-5")
        end
    end
end

def center_reviews
    systemclear("#{$selected_center.center} Pokemon Center Reviews")
    Pokemon.losing_hp
    $cliuser.check_hp
    center_revs = Review.all.select {|review| review.center == $selected_center}
    center_review = center_revs.map {|rev| rev.show_review}
    if center_review.empty?
        puts "There are no reviews yet for this Center"
    else 
        puts center_review
        puts "Average Rating: #{$selected_center.average_rating}"
    end
    $prompt.keypress("Press space or enter to go back", keys: [:space, :return])
    pokecenter_menu
end

def select_review
    rev_user = Review.all.select {|rev| rev.user == $cliuser && rev.center == $selected_center}
    Pokemon.losing_hp
    $cliuser.check_hp
    if rev_user.empty?
        puts "You have not reviewed this Center yet"
        $prompt.keypress("Press space or enter to go back", keys: [:space, :return])
        pokecenter_menu
    else 
    review_list = rev_user.map {|rev| rev.content}
    review = $prompt.select('Please select a Review', [review_list])
    $selected_review = Review.all.find_by(content: review)
    end
end

def edit_review
    systemclear("Edit your #{$selected_center.center} Reviews")
    select_review
    edit = $prompt.select("Edit #{$selected_review.content}?", ["Yes", "No"])
        if edit == "Yes"
            puts "Please write a new review"
            $selected_review.content = gets.chomp
            $selected_review.save
            puts "Please give a new rating"
            $selected_review.rating = check
            $selected_review.save
            $prompt.ok("Done.")
            Pokemon.losing_hp
            pokecenter_menu
        else edit == "No"
            Pokemon.losing_hp
            pokecenter_menu
        end
end

def delete_review
    systemclear("Delete your #{$selected_center.center} Reviews")
    select_review
    delete = $prompt.select("Delete #{$selected_review.content}?", ["Yes", "No"])
        if delete == "Yes"
            Review.all.where(id: $selected_review.id).destroy_all
            $selected_review = ''
            $prompt.ok("Done.")
            play_delete
            sleep 3
            play_pokecenter_music
            Pokemon.losing_hp
            pokecenter_menu
        else delete == "No"
            Pokemon.losing_hp
            pokecenter_menu
        end
end

