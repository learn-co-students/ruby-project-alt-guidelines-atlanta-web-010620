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
        selection = select("Log in or make account:", ["Log In", "New Account"])
        if selection == "Log In"
            user_name = self.ask("Enter username: ")
            password = self.mask("Enter password: ")
            if Account.exists?(user_name: user_name, password: password)
                account = Account.find_by(user_name: user_name, password: password)
                account.user.menu(self)
            else
                puts "User does not exist"
                self.log_in
            end
        else
            create_user
        end
    end

    def create_user
        user_name = ask("Enter username: ")
        password = mask("Enter password: ")
        p_or_dm = select("Is this account for a Player or Dungeon Master?", ["Player", "Dungeon Master"])
        if p_or_dm == "Player"
            user = create_player
        else
            user = create_dm
        end
        account = Account.create(user_name: user_name, password: password, user: user)
        account.user.menu(self)
    end

    def create_player
        puts "Making new player profile"
        name = self.ask("What is your name?")
        availability = self.select("What day are you available to play?", %w(Monday Tuesday Wednesday Thursday Friday Saturday Sunday))
        Player.create(name: name, availability: availability)
    end

    def create_dm
        Dm.create(name: self.ask("What is your name?"))
    end

    

    def player_change_day(player)
        player.availability = self.select("What day are you available to play?", %w(Monday Tuesday Wednesday Thursday Friday Saturday Sunday))
        player.menu(self)
    end

    def player_list_characters(player)
        player.characters.each{|character| puts "#{character.name} the #{character.character_class}"}
        player.menu(self)
    end

    def player_list_campaigns(player)
        puts player.campaigns.map{|campaign| campaign.world}
        player.menu(self)
    end

    def player_find_campaign(player)
        if player.find_campaigns_by_day_and_opening.any?
            campaign = player.find_campaigns_by_day_and_opening.map{|campaign| "#{campaign.world} ran by #{campaign.dm.name} on #{campaign.day_of_play}"}
            puts campaign
            pick = self.yes?("Make a character for any of these campaigns?")
            if pick
                selection = self.select("Which campaign?", campaign)
                selection = selection.split(" ran by ")
                world = selection[0]
                selection = selection[1].split(" on ")[0]
                campaign = Campaign.find_by(dm_id: Dm.find_by(name: selection).id, day_of_play: player.availability, world: world)
                player_make_character(player, campaign)
            end
        else
            puts "There's no campaign on your day off!"
        end
        player.menu(self)
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
        end
        puts final_stats
        health = 10 + final_stats[:constitution]
        block = {name: name, character_class: character_class, race: race, armor_class: armor_class, max_health: health, current_health: health, level: 1, player_id: player.id, campaign_id: campaign.id}
        block = block.merge(final_stats)
        character = Character.create(block)
        player.characters.reload
        puts "\nCongratulations, your character is complete"
        puts "#{character.name} the #{character.character_class}"
    end

    def player_destroy_character(player)
        if player.characters.empty?
            puts "No characters to select!"
            sleep(1)
        else
            character = self.select("What character would you like to delete?", player.characters.map{|character| character.name})
            character = Character.find_by(name: character)
            answer = self.yes?("Do you really want to delete #{character.name} the #{character.race} #{character.character_class}")
            if answer
                puts "Bye bye #{character.name}"
                Character.destroy(character.id)
                player.characters.reload
                player.campaigns.reload
                player.save
            end
        end
        player.menu(self)
    end

    def select_character(player)
        if player.characters.empty?
            puts "No characters to select!"
            sleep(1)
            player.menu(self)
        else
            character = self.select("What character would you like to manage?", player.characters.map{|character| character.name})
            character = Character.find_by(name: character)
            character_menu(character)
        end
    end

    def character_menu(character)
        selection = self.select("#{character.name}'s Menu", ["Party List", "Attack Party Member", "Heal Party Member", "Back to Player Menu", "Exit"])
        if selection == "Party List"
            puts character.party_members
            character_menu(character)
        elsif selection == "Attack Party Member"
            attack_party_member(character)
        elsif selection == "Heal Party Member"
            heal_party_member(character)
        elsif selection == "Back to Player Menu"
            character.player.menu(self)
        else
            puts "Exiting"
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

end