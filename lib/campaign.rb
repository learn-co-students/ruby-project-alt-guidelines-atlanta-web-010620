class Campaign < ActiveRecord::Base

    has_many :characters
    has_many :players, through: :characters
    belongs_to :dm

    def player_opening?
        if max_players > players.size
            return true
        else
            return false
        end
    end
    
    def find_players_with_availability
        Player.where(availability: self.day_of_play)
    end
    
    def find_players_with_availability_and_no_campaign
        find_players_with_availability.select{|player| player.campaigns == []}.map{|player| player.name}
    end
end

