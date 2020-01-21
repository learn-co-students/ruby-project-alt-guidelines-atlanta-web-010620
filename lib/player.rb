class Player < ActiveRecord::Base
    has_many :characters
    has_many :campaigns, through: :characters

    def roll(times, dice, drop = 0)
        rolls = []
        times.times do 
            rolls << rand(1..dice)
        end
        rolls.sort.drop(drop).sum
    end

    def roll_starter_stats
        rolls = []
        7.times {rolls << roll(4,6,1)}
        rolls.sort.drop(1).reverse
    end

    def roll_character_stats
        {strength: roll(4,6,1), dexterity: roll(4,6,1), constitution: roll(4,6,1), wisdom: roll(4,6,1), intelligence: roll(4,6,1), charisma: roll(4,6,1)}
    end

    def make_character(name, character_class, race, armor_class, max_health, campaign_id)
        character_hash = {name: name, character_class: character_class, race: race, armor_class: armor_class, level: 1, current_health: max_health, max_health: max_health, player_id: self.id, campaign_id: campaign_id}
        character_hash = character_hash.merge(self.roll_character_stats)
        Character.create(character_hash)
    end

    def find_campaigns_by_day
        Campaign.where(day_of_play: self.availability)
    end

    def find_campaigns_by_opening 
        Campaign.all.select{|campaign| campaign.player_opening?}
    end

    def find_campaigns_by_day_and_opening
        find_campaigns_by_day & find_campaigns_by_opening
    end
end