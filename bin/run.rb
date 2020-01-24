require_relative '../config/environment'
pid = fork{exec 'afplay', "pokemonmusic.mp3"}

old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil

cli = CommandLineInterface.new  
cli.run
cli.first_pokemon
cli.choose_path
sleep(3)


  