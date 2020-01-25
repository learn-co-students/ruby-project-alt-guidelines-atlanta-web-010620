class Actor < ActiveRecord::Base
    has_many :quotes
    has_many :productions, through: :quotes
    has_many :games
end