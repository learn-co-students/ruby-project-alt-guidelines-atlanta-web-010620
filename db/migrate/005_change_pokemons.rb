class ChangePokemons < ActiveRecord::Migration[5.1]
    def change
        change_column_default :pokemons, :health, 100
    end
end