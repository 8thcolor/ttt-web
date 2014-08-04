class SavedGamesController < ApplicationController

  def index
    @saved_games = SavedGame.all
  end

  def show
    @saved_game = SavedGame.find(params[:id])
  end

  def play
    @saved_game = SavedGame.find(params[:id])

    x = params[:x].to_i
    y = params[:y].to_i

    @saved_game.play_turn(x,y)
    
    redirect_to action: 'show'
  end

  def new
    @saved_game = SavedGame.new
    @saved_game.status = 'ongoing'
    game = Game.new(1)
    player = Player.new(game, 1)
    player.play

    @saved_game.data = game.save
    @saved_game.save

    redirect_to @saved_game, notice: 'Saved game was successfully created.'
  end

  def destroy
    @saved_game = SavedGame.find(params[:id])
    @saved_game.destroy
    redirect_to saved_games_url
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def saved_game_params
      params.require(:saved_game).permit(:data)
    end
end
