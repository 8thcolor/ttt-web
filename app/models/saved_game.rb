class SavedGame < ActiveRecord::Base
  def lost?
    status == 'lost'
  end

  def play_turn(x, y)
    game.place(x, y)
    
    unless game.finish?
      player = Player.new(game, 1)
      player.play
    end

    self.data = game.save
    
    if game.winner == -1
      self.status = 'won'
    elsif game.winner == 1
      self.status = 'lost'
    end

    save

  end

  def game
    @game ||= Game::load(data)
  end

  def grid_s
    grid_str = "  0 1 2\n"
    (0..2).each do |y|
      grid_str << y.to_s + " " 
      (0..2).each do |x|
        grid_str << game.show_at(y,x) + " "
      end
      grid_str << "\n"
    end
    grid_str
  end
end
