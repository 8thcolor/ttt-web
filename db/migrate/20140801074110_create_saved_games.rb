class CreateSavedGames < ActiveRecord::Migration
  def change
    create_table :saved_games do |t|
      t.string :data

      t.timestamps
    end
  end
end
