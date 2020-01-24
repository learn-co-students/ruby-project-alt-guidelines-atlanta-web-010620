class Pokemon < ActiveRecord::Base
   belongs_to :trainer
   belongs_to :type

   def self.wild_pokemon
      Pokemon.all.map{|poke| poke.name}.uniq.sample
   end

   def self.types
      Pokemon.all.map{|poke| poke.type}.collect{|types| types}.uniq
   end

   def current_type
   end

   def super_effective?(enemy)
      case self.type
      when "Dark"
       if enemy.type == "Psychic" || enemy.type == "Ghost"
         true
       end
      when "Fighting"
         if enemy.type == "Normal" || enemy.type == "Steel" || enemy.type == "Rock"
           true
         end
      when "Bug"
         if enemy.type == "Psychic" || enemy.type == "Grass" || enemy.type == "Dark"
           true
         end
      when "Poison"
         if enemy.type == "Grass"
            true
         end
      when "Fire"
         if enemy.type == "Grass" || enemy.type == "Steel" || enemy.type == "Bug"
            true
         end
      when "Flying"
         if enemy.type == "Fighting" || enemy.type == "Bug" || enemy.type == "Grass"
            true
         end
      when "Ghost"
         if  enemy.type == "Ghost" || enemy.type == "Psychic"
            true
         end
      when "Electric"
         if enemy.type == "Water" || enemy.type == "Flying"
            true
         end
      when "Water"
         if enemy.type == "Rock" || enemy.type == "Ground" || enemy.type == "Fire"
            true
         end 
      when "Rock"
         if enemy.type == "Bug" || enemy.type == "Fire" || enemy.type == "Flying"
            true
         end
      when "Ground"
         if enemy.type == "Steel" || enemy.type == "Fire" || enemy.type == "Electric" || enemy.type == "Rock" || enemy.type == "Poison"
            true
         end
      when "Psychic"
         if enemy.type == "Fighting" || enemy.type == "Poison"
            true
         end
      when "Steel"
         if enemy.type == "Rock"
            true
         end
      when "Normal"
         false
      when "Grass"
         if enemy.type == "Water" || enemy.type == "Rock" || enemy.type == "Ground"
            true
         end
      else
         false
      end

   end
      
       def attack(enemy, trainer)
          puts "#{self.name} attacks #{enemy.name}"
          sleep(3)
          #enemy_pokemon = Pokemon.find_by(name: enemy.type.name, trainer_id: trainer.id)
          puts "#{self.name} attacked #{enemy.name}"
          while enemy.health > 0
             if super_effective?(enemy)
                puts "It was super effective"
             enemy.health -= 100
             else
                puts "#{enemy.name} lost half its health"
                enemy.health -= 50
                sleep(3)
                if enemy.health < 1
                  puts "#{enemy.name} has fainted"
                end
             end
          end
       end

     

   

end