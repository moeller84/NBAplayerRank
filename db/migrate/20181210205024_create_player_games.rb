class CreatePlayerGames < ActiveRecord::Migration[5.1]
  def change
    create_table :player_games do |t|
      t.integer :no_points
      t.integer :no_rebounds
      t.integer :no_assists
      t.integer :no_blocks
      t.integer :no_steals
      t.integer :no_tpm
      t.integer :no_fta
      t.integer :no_ftm
      t.integer :no_fga
      t.integer :no_fgm
      t.integer :no_turnovers
      t.references :player, foreign_key: true
      t.references :game, foreign_key: true

      t.timestamps
    end
  end
end
