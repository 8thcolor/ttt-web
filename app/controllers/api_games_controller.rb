class ApiGamesController < ApplicationController
  skip_before_filter :verify_authenticity_token

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

    @saved_game.play_turn(x, y)

    render action: 'show', status: :created, location: @saved_game
  end

  # POST /saved_games
  # POST /saved_games.json
  def create
    @saved_game = SavedGame.new
    @saved_game.status = 'ongoing'
    game = Game.new(1)
    player = Player.new(game, 1)
    player.play
    
    @saved_game.data = game.save
    @saved_game.save

    render action: 'show', status: :created, location: @saved_game
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def saved_game_params
      params.require(:saved_game).permit(:data)
    end
end
