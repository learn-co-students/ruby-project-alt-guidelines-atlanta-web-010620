class CreateQuotes < ActiveRecord::Migration[5.2]
  def change
    create_table :quotes do |t|
      t.string :quote
      t.integer :actor_id
      t.integer :production_id
    end
  end
end
