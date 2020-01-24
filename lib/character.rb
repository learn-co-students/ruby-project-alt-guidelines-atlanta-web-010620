class Character < ActiveRecord::Base
    belongs_to :player
    belongs_to :campaign
    @@pastel = Pastel.new

    def death_saving
        death_fail = 0
        death_save = 0
        puts "#{self.name} is downed!"
        sleep(1)
        puts "Roll 3 times a 10 or above on a d20 to stablilize."
        sleep(1)
        puts "However, roll 3 times below a 10 and #{self.name} dies!"
        sleep(1)
        until death_fail > 2 || death_save > 2
            roll = rand(1..20)
            puts "You rolled a #{roll}!"
            sleep(1)
            if roll == 20
                death_save += 2
            elsif roll >= 10 && roll < 20
                death_save += 1
            elsif roll >= 2 && roll < 10
                death_fail += 1
            else
                death_fail +=2
            end
            puts "Death saves: #{death_save}   Death fails: #{death_fail}"
            sleep(1)
        end
        if death_save > 2
            self.current_health = 1
            self.save
            puts "#{self.name} stablizes with one health"
        else
            CommandLineInterface.death
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
        puts @@pastel.red("#{self.name} rolled a #{roll} against #{target.name}'s armor class of #{target.armor_class}")
        sleep(1)
        puts ""
        damage = 0
        if roll >= target.armor_class
            if roll - bonus == 1
                puts @@pastel.red("Critical fail!")
                failure = self.player.roll(2, 5)
                sleep(1)
                puts @@pastel.red("#{self.name} trips and falls for #{failure} damage")
                take_damage(failure)
            elsif roll - bonus == 20
                puts @@pastel.yellow"Critical success!"
                damage = self.player.roll(2, 8) + bonus
            else
                damage = self.player.roll(1, 8) + bonus
            end
            sleep(1)
            target.take_damage(damage)
        else
            puts "#{self.name} missed!"
        end
    end

    def heal(target)
        puts "#{self.name} does some field surgery on #{target.name}."
        sleep(1)
        puts "#{self.name} rolls 2d4 + 1 to heal with a potion"
        roll = self.player.roll(2, 4) + 1
        sleep(1)
        target.heal_damage(roll)
    end

    def stats
        puts "#{self.name}'s stats:"
        puts "Strength: #{self.strength}"
        puts "Dexterity: #{self.dexterity}"
        puts "Constitution: #{self.constitution}"
        puts "Intelligence: #{self.intelligence}"
        puts "Wisdom: #{self.wisdom}"
        puts "Charisma: #{self.charisma}"
    end
end