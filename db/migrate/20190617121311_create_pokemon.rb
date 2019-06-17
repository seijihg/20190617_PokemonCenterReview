class CreatePokemon < ActiveRecord::Migration[5.2]
  def change
    def create_table :pokemons do |t|
      t.string :name
      t.string :type
      t.string :location_area
      t.integer :hp
    end
  end
end
