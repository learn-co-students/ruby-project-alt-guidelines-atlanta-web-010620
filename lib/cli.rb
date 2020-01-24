require 'tty-prompt'
require 'pry'
class CommandLineInterface

    attr_accessor :user

    def initialize
    @prompt = TTY::Prompt.new
    @user = {}
    end



    def greet
        puts "Hello! Lettuce get this party started!"
       if @prompt.yes?("Are you a new user?")
        name = @prompt.ask("Please enter your name:", required: true)
        username = @prompt.ask("Please create username:", required: true)
        password = @prompt.mask("Please create password:", required: true)
        self.user = User.create(name: name, username: username, password: password)
       else
        username = @prompt.ask("Welcome back, please login with username:", required: true)
        self.user = User.find_by(username: username)
        user_password = @prompt.mask("Please input password here:", required: true)
            if user.password == user_password 
                 self.user = user
            else 
                self.greet
            end 

        end
    end

    def homepage
        puts "Welcome to your homepage! #{self.user.name}!"
    end

    def game
      options = ["new game", "past results"]
      choice = @prompt.select("Which would you like to choose?", options, cycle: true)
      if choice == options[0]
      choose_actor = @prompt.select("Pick one of the following:", Actor.all.map { |actor| actor.name }, cycle: true)
        actor = Actor.find_by(name: choose_actor)
         new_game = Game.create(user_id: self.user.id, actor_id: actor.id, score: 0)
        puts "So you think you know #{actor.name}?!"
        sleep(1)
        new_game.start_game
      else
       results = self.user.games.map {|game| game.actor.name}.uniq
       puts results
      end
      exit
    end

    def exit
      if @prompt.yes?("Would you like to logout?")
        sleep(2)
        puts "Come back sometime!"
        sleep(1)
      else
        self.game
      end
    end





end