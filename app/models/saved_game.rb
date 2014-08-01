class SavedGame < ActiveRecord::Base
  def lost?
    status == 'lost'
  end

  def game
    @game ||= Game::load(data)
  end
end
