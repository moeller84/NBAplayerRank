class CreatePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|
      t.string :firstName
      t.string :lastName
      t.integer :personId
      t.integer :teamId

      t.timestamps
    end
  end
end
