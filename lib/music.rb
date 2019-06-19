def play_opening_music
    system("killall afplay")
    fork{ exec 'afplay', "poke_music/opening_pokemon.mp3" }
end

def play_pokecenter_music
    system("killall afplay")
    fork{ exec 'afplay', "poke_music/pokemon_center.mp3" }
end

def play_delete
    fork{ exec 'afplay', "poke_music/delete_review.mp3" }
end

def play_scream
    fork{ exec 'afplay', "poke_music/scream.mp3" }
end
