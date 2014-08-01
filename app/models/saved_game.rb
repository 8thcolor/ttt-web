class SavedGame < ActiveRecord::Base
  def lost?
    status == 'lost'
  end

  def game
    Game::load(data)
  end
end
