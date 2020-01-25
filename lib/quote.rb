class Quote < ActiveRecord::Base
    belongs_to :actor
    belongs_to :production
end