class Character < ActiveRecord::Base
    belongs_to :player
    belongs_to :campaign
    def death_saving
        death_fail = 0
        death_save = 0
        puts "#{self.name} is downed!"
        puts "Roll 3 times a 10 or above on a d20 to stablilize."
        puts "However, roll 3 times below a 10 and #{self.name} dies!"
        until death_fail > 2 || death_save > 2
            roll = rand(1..20)
            puts "You rolled a #{roll}!"
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
            puts "#{self.name} stablizes with one health"
        else
            puts "#{self.name} died!"
        end
    end
    
    def take_damage(damage)
        puts "#{self.name} takes #{damage} damage."
        self.current_health = self.current_health - damage
        if current_health <= 0
            death_saving
        else
            self.save 
            puts "#{self.name} is left with #{current_health} health"
        end
    end

    def heal_damage(damage)
        puts "#{self.name} heals for #{damage} damage."
        self.current_health = self.current_health + damage
        if current_health > max_health
            current_health = max_health
        end
        self.save 
        puts "#{self.name}'s health is now #{self.current_health}"
    end

    def party_members
        party = campaign.characters.map{|character| "#{character.name} the #{character.race} #{character.character_class}"}
        party.delete("#{self.name} the #{self.race} #{self.character_class}")
        party
    end

    def attack(attribute, target)
        puts "#{self.name} makes a #{attribute} attack on #{target.name}!"
        bonus = (self[attribute.to_sym] -10)/2
        sleep(1)
        puts "#{self.name} rolls a d20 with a bonus of #{bonus} to hit"
        roll = rand(1..20) + bonus
        3.times do
            print "."
            sleep(1)
        end
        puts ""
        damage = 0
        if roll - bonus == 1
            puts "Critical fail!"
            failure = self.player.roll(2, 5)
            sleep(1)
            puts "#{self.name} trips and falls for #{failure} damage"
            take_damage(failure)
        elsif roll - bonus == 20
            puts "Critical success!"
            damage = self.player.roll(2, 8) + bonus
        else
            damage = self.player.roll(1, 8) + bonus
        end
        target.take_damage(damage)
    end

    def heal(target)
        puts "#{self.name} does some field surgery on #{target.name}."
        sleep(1)
        puts "#{self.name} rolls 2d4 + 1 to heal with a potion"
        roll = self.player.roll(2, 4) + 1
        sleep(1)
        target.heal_damage(roll)
    end
end