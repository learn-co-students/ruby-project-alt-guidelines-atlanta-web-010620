class Dm < ActiveRecord::Base
    has_many :campaigns
    has_many :characters, through: :campaigns
    has_many :accounts, as: :user
    
    def menu(cli)
        @cli = cli 
        selection = @cli.select("DM Main Menu", ["List Campaigns", "List Players", "List Characters", "Find Players", "Create Campaign", "Exit"])
        if selection == "List Campaigns"
            list_campaigns
        elsif selection == "List Players"
            list_players
        elsif selection == "List Characters"
            list_characters
        elsif selection == "Find Players"
            find_players
        elsif selection == "Create Campaign"
            create_campaign
        else
            puts "Exiting"
        end
    end

    def create_campaign
        day = @cli.select("What day are you running your campaign?", %w(Monday Tuesday Wednesday Thursday Friday Saturday Sunday))
        world = @cli.ask("What is the name/theme of your world?")
        max_players = @cli.ask("How many players would you like to set as your max?").to_i
        campaign = Campaign.create(dm_id: self.id, day_of_play: day, world: world, max_players: max_players)
        self.reload
        puts "#{campaign.world}, held on #{campaign.day_of_play}"
        menu(@cli)
    end

    def list_campaigns
        puts self.campaigns.map{|campaign| "#{campaign.world}, held on #{campaign.day_of_play}"}
        menu(@cli)
    end

    def list_players
        puts self.characters.map{|character| character.player.name}.uniq
        menu(@cli)
    end

    def list_characters
        puts self.characters.map{|character| character.name}
        menu(@cli)
    end

    def find_players
        player_list = []
        campaigns.each do |campaign|
            player_list << campaign.find_players_with_availability
        end
        player_list.flatten.uniq.each{|player| puts "#{player.name} is free on #{player.availability}"}
        menu(@cli)
    end
end