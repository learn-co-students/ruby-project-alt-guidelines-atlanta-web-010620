class CreatePokemon < ActiveRecord::Migration[5.1]
    def change
    create_table :pokemons do |t|
        t.string :name
        t.integer :type_id
        t.integer :trainer_id
    end
end

end