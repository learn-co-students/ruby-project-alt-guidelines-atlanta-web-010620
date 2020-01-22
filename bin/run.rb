require_relative '../config/environment'

system "clear"
pastel = Pastel.new
cli = CommandLineInterface.new
old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil

cli.greet
cli.log_in

ActiveRecord::Base.logger = old_logger