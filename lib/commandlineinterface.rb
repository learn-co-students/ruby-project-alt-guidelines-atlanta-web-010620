class CommandLineInterface < TTY::Prompt
    pastel = Pastel.new

    def greet
        pastel = Pastel.new
        puts pastel.green("Hello! And welcome to the Adventurers League Finder App\n")
        puts pastel.green("
        
                                              /|                                                                        
                                             |\\|                                                                       
                                             |||                                                                       
                                             |||                                                                       
                                             |||                                                                       
                                             |||                                                                       
                                             |||                                                                       
                                             |||                                                                       
                                          ~-[{o}]-~                                                                    
                                             |/|                                                                       
                                             |/|                                                                       
                     ///~`     |\\\\_          `0'         =\\\\\\\\         . .                                        
                    ,  |='  ,))\\_| ~-_                    _)  \\      _/_/|                                            
                   / ,' ,;((((((    ~ \\                  `~~~\\-~-_ /~ (_/\\                                           
                 /' -~/~)))))))'\\_   _/'                      \\_  /'  D   |                                           
                (       (((((( ~-/ ~-/                          ~-;  /    \\--_                                         
                 ~~--|   ))''    ')  `                            `~~\\_    \\   )                                      
                     :        (_  ~\\           ,                    /~~-     ./                                        
                      \\        \\_   )--__  /(_/)                   |    )    )|                                       
            ___       |_     \\__/~-__    ~~   ,'      /,_;,   __--(   _/      |                                        
          //~~\\`\\    /' ~~~----|     ~~~~~~~~'        \\-  ((~~    __-~        |                                      
        ((()   `\\`\\_(_     _-~~-\\                      ``~~ ~~~~~~   \\_      /                                      
         )))     ~----'   /      \\                                   )       )                                         
          (         ;`~--'        :                                _-    ,;;(                                               
                    |    `\\       |                             _-~    ,;;;;)                                              
                    |    /'`\\     ;                          _-~          _/                                               
                   /~   /    |    )                         /;;;''  ,;;:-~                                                  
                  |    /     / | /                         |;;'   ,''                                                       
                  /   /     |  \\|                         |   ,;(                                               
                _/  /'       \  \_)                   .---__\\_    \\,--._______                                 
               ( )|'         (~-_|                   (;;'  ;;;~~~/' `;;|  `;;;\\                                 
                ) `\\_         |-_;;--__               ~~~----__/'    /'_______/                                 
                `----'       (   `~--_ ~~~;;------------~~~~~ ;;;'_/'                                          
                             `~~~~~~~~'~~~-----....___;;;____---~~                                                  
                  ")  #Art by Tua Xiong
    end

    def log_in
        self.yes?('Are you a returning user?')   
    end

    def p_or_dm
        self.select('Are you a player or DM? (Dungeon Master)', %w(Player DM))
    end

    def log_in_player
        name = self.ask("Enter name")
        if Player.find_by(name: name)
            player = Player.find_by(name: name)
        else
            puts "ERROR: Player not found"
            self.log_in_player
        end
    end

    def create_player
        puts "Making new player profile"
        name = self.ask("What is your name?")
        availability = self.select("What day are you available to play?", %w(Monday Tuesday Wednesday Thursday Friday Saturday Sunday))
        Player.create(name: name, availability: availability)
    end

    def make_dm
        self.ask("What is your name?")
    end

    def player_menu(player)
        selection = self.select("Player Main Menu", ["List Characters", "List Campaigns", "Find Campaign", "Change Day Availability", "Delete Character", "Character Menus", "Exit"])
            if selection == "List Characters"
                player_list_characters(player)
            elsif selection == "List Campaigns"
                player_list_campaigns(player)
            elsif selection == "Find Campaign"
                player_find_campaign(player)
            elsif selection == "Change Day Availability"
                player_change_day(player)
            elsif selection == "Delete Character"
                player_destroy_character(player)
            elsif selection == "Character Menus"
                select_character(player)
            else
                puts "Exiting"
            end
    end

    def player_change_day(player)
        player.availability = self.select("What day are you available to play?", %w(Monday Tuesday Wednesday Thursday Friday Saturday Sunday))
        player_menu(player)
    end

    def player_list_characters(player)
        puts player.characters.map{|character| "#{character.name} the #{character.character_class}"}
        player_menu(player)
    end

    def player_list_campaigns(player)
        puts player.campaigns.map{|campaign| campaign.world}
        player_menu(player)
    end

    def player_find_campaign(player)
        if player.find_campaigns_by_day_and_opening.any?
            campaign = player.find_campaigns_by_day_and_opening.map{|campaign| "#{campaign.world} ran by #{campaign.dungeon_master} on #{campaign.day_of_play}"}
            puts campaign
            pick = self.yes?("Make a character for any of these campaigns?")
            if pick
                selection = self.select("Which campaign?", campaign)
                selection = selection.split(" ran by ")[1].split(" on ")[0]
                campaign = Campaign.find_by(dungeon_master: selection)
                player_make_character(player, campaign)
            end
        else
            puts "There's no campaign on your day off!"
        end
        player_menu(player)
    end

    def player_make_character(player, campaign)
        character_class_array = ["Barbarian", "Bard", "Cleric", "Druid", "Fighter", "Monk", "Paladin", "Ranger", "Rogue", "Sorcerer", "Warlock", "Wizard"]
        character_race_array = ["Dragonborn", "Dwarf", "Elf", "Gnome", "Half-elf", "Halfling", "Half-orc", "Human", "Tiefling"]
        name = self.ask("Make a name for your character:")
        character_class = self.select("What class is #{name}?", character_class_array)
        race = self.select("What race is #{name}?", character_race_array)
        armor_class = self.ask("What is your armor class?")
        puts "Rolling for starting stat pool..."
        sleep(1)
        stat_pool = player.roll_starter_stats
        puts "Your stat pool is #{stat_pool}"
        attributes = ["strength", "dexterity", "constitution", "wisdom", "intelligence", "charisma"]
        final_stats = {}
        stat_pool.each do |x|
            attri = self.select("Select an attribute to assign #{x}", attributes)
            final_stats.merge!(attri.to_sym => x)
            puts final_stats
            puts attri
            attributes.delete(attri)
            x += 1
        end
        puts final_stats
        health = 10 + final_stats[:constitution]
        block = {name: name, character_class: character_class, race: race, armor_class: armor_class, max_health: health, current_health: health, level: 1, player_id: player.id, campaign_id: campaign.id}
        block = block.merge(final_stats)
        character = Character.create(block)
        "Congratulations, your character is complete"
        puts "#{character.name} the #{character.character_class}"
    end

    def player_destroy_character(player)
        character = self.select("What character would you like to delete?", player.characters.map{|character| character.name})
        character = Character.find_by(name: character)
        answer = self.yes?("Do you really want to delete #{character.name} the #{character.race} #{character.character_class}")
        if answer
            puts "Bye bye #{character.name}"
            Character.destroy(character.id) 
        end
        player_menu(player)
    end

    def select_character(player)
        character = self.select("What character would you like to manage?", player.characters.map{|character| character.name})
        character = Character.find_by(name: character)
        character_menu(character)
    end

    def character_menu(character)
        selection = self.select("#{character.name}'s Menu", ["Party List", "Attack Party Member", "Heal Party Member", "Exit"])
        if selection == "Party List"
            puts character.party_members
            character_menu(character)
        elsif selection == "Attack Party Member"
            attack_party_member(character)
        elsif selection == "Heal Party Member"
            heal_party_member(character)
        end
    end

    def attack_party_member(character)
        pastel = Pastel.new
        puts pastel.red("
                   _
        _         | |
       | | _______| |---------------------------------------------\\
       |:-)_______|==[]============================================>
       |_|        | |---------------------------------------------/
                  |_|
        ")
        puts "Mutiny! Division in the ranks! Betrayl!"
        sleep(1) 
        2.times do
            print "." 
            sleep(1)
        end
        puts "Or, you just think they are mad ugly"
        sleep(2)
        target = self.select("Pick a party member to attack", character.party_members)
        target = Character.find_by(name: target.split(" the ")[0])
        pp character
        attribute = self.select("Which attribute would you like to attack with?", ["strength", "dexterity", "constitution", "wisdom", "intelligence", "charisma"])
        character.attack(attribute, target)
        character_menu(character)
    end

    def heal_party_member(character)
        puts "Oh no! Somebody has an owie"
        sleep(1)
        target = self.select("Pick a party member to heal", character.party_members)
        target = Character.find_by(name: target.split(" the ")[0])
        character.heal(target)
        character_menu(character)
    end

    def dm_menu(dm) 
        selection = self.select("DM Main Menu", ["List Campaigns", "List Players", "List Characters", "Find Players", "Create Campaign", "Exit"])
        if selection == "List Campaigns"
            dm_list_campaigns(dm)
        elsif selection == "List Players"
            dm_list_players(dm)
        elsif selection == "List Characters"
            dm_list_characters(dm)
        elsif selection == "Find Players"
            dm_find_players(dm)
        elsif selection == "Create Campaign"
            create_campaign(dm)
        end
    end

    def dm_list_campaigns(dm)
        pp Campaign.where(dungeon_master: dm)
        dm_menu(menu)
    end

    def dm_list_players(dm)
        pp dm_list_campaigns(dm).map{|campaign| campaign.players}
        dm_menu(dm)
    end

    def dm_list_characters(dm)
        pp dm_list_campaigns(dm).map{|campaign| campaign.characters}
        dm_menu(dm)
    end

    def dm_find_players(dm)
        pp Campaign.find_by(dungeon_master: dm).find_players_with_availability
        dm_menu(dm)
    end

    def create_campaign(dm) 
        day = self.select("What day are you running your campaign?", %w(Monday Tuesday Wednesday Thursday Friday Saturday Sunday))
        world = self.ask("What is the name/theme of your world?")
        bbg = self.ask("What is the name of your main bad guy?")
        max_players = self.ask("How many players would you like to set as your max?").to_i
        campaign = Campaign.create(dungeon_master: dm, day_of_play: day, world: world, bbg: bbg, max_players: max_players)
        pp campaign
        dm_menu(dm)
    end
end