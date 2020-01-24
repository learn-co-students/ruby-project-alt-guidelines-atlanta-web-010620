class CreateDms < ActiveRecord::Migration[5.2]
    def change
        create_table :dms do |t|
            t.string :name
        end
    end
end