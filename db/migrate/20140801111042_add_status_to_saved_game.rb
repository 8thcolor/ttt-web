class AddStatusToSavedGame < ActiveRecord::Migration
  def change
    add_column :saved_games, :status, :string
  end
end
