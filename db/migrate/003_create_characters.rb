class CreateCharacters < ActiveRecord::Migration[5.2]
    def change
        create_table :characters do |t|
            t.string :name
            t.string :character_class
            t.string :race
            t.integer :level
            t.integer :armor_class
            t.integer :current_health
            t.integer :max_health
            t.integer :strength
            t.integer :dexterity
            t.integer :wisdom
            t.integer :intelligence
            t.integer :charisma
            t.integer :constitution
        end
    end
end