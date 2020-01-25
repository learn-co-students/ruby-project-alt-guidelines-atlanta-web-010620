class User < ActiveRecord::Base
    has_many :games
    has_many :actors, through: :games


end