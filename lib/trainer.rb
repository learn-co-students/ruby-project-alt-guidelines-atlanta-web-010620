class Trainer < ActiveRecord::Base
    has_many :pokemon
    has_many :types, through: :pokemon

    def self.random_trainer
        Trainer.all.map{|trainer| trainer}.sample
    end

    def view_pokemon
    Pokemon.all.select{|poke| poke.trainer_id == self.id}
    end

    def view_types
        view_pokemon.map{|poke| poke.type.name}.uniq
    end

    def catch_pokemon
        temp = Pokemon.wild_pokemon
        Pokemon.create(name: temp, trainer_id: self.id, type_id: Type.all.sample.id)
    end
 
    def fight
    end
end