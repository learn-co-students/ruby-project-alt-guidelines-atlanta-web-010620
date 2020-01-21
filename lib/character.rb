class Character < ActiveRecord::Base
    belongs_to :player
    belongs_to :campaign
    def death_saving
        death_fail = 0
        death_save = 0
        puts "You are downed!"
        puts "Roll 3 times a 10 or above on a d20 to stablilize."
        puts "However, roll 3 times below a 10 and you die!"
        until death_fail > 2 || death_save > 2
            roll = rand(1..20)
            put "You rolled a #{roll}!"
            if roll == 20
                death_save += 2
            elsif roll >= 10 && roll < 20
                death_save += 1
            elsif roll >= 2 && roll < 10
                death_fail += 1
            else
                death_fail +=2
            end
        end
        if death_save > 2
            self.current_health = 1
            self.save
            puts "You stablize with one health"
        else
            puts "You died!"
        end
    end
    
    def take_damage(damage)
        puts "You take #{damage} damage."
        current_health -= damage
        if current_health <= 0
            death_saving
        else
            self.save 
            puts "You are left with #{current_health} health"
        end
    end

    def heal_damage(damage)
        puts "You heal for #{damage} damage."
        current_health += damage
        if current_health > max_health
            current_health = max_health
        end
        self.save 
        puts "Your health is now #{current_health}"
    end

end