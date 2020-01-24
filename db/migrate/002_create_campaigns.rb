class CreateCampaigns < ActiveRecord::Migration[5.2]
    def change
        create_table :campaigns do |t|
            t.string :world
            t.string :day_of_play
            t.integer :max_players
            t.integer :dm_id
        end
    end
end