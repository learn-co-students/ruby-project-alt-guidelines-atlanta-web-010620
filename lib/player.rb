class Player < ActiveRecord::Base
    has_many :characters
    has_many :campaigns, through: :characters
    has_many :accounts, as: :user

    def roll(times, dice, drop = 0)
        rolls = []
        times.times do 
            rolls << rand(1..dice)
        end
        rolls.sort.drop(drop).sum
    end

    def roll_starter_stats
        stats = []
        7.times do
            stats << roll(4,6,1)
        end
        stats.sort.reverse.first(6)
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

    def menu(cli)
        selection = cli.select("Player Main Menu", ["List Characters", "List Campaigns", "Find Campaign", "Change Day Availability", "Delete Character", "Character Menus", "Exit"])
            if selection == "List Characters"
                cli.player_list_characters(self)
            elsif selection == "List Campaigns"
                cli.player_list_campaigns(self)
            elsif selection == "Find Campaign"
                cli.player_find_campaign(self)
            elsif selection == "Change Day Availability"
                cli.player_change_day(self)
            elsif selection == "Delete Character"
                cli.player_destroy_character(self)
            elsif selection == "Character Menus"
                cli.select_character(self)
            else
                puts "Exiting"
            end
    end
end