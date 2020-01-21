class CreateCampaigns < ActiveRecord::Migration[5.2]
    def change
        create_table :campaigns do |t|
            t.string :dungeon_master
            t.string :world
            t.string :bbg
            t.string :day_of_play
            t.integer :max_players
        end
    end
end