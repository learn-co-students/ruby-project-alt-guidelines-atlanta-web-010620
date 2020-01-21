require_relative '../config/environment'

system "clear"

cli = CommandLineInterface.new
old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil

cli.greet
returning = cli.log_in
p_or_dm = cli.p_or_dm
if returning
    if p_or_dm == "Player"
        player = cli.log_in_player
        cli.player_menu(player)
    else
        dm = cli.make_dm
        cli.dm_menu(dm)
    end
else
    if p_or_dm == "Player"
        player = cli.create_player
        cli.player_menu(player)
    else
        dm = cli.make_dm
        cli.dm_menu(dm)
    end
end

ActiveRecord::Base.logger = old_logger