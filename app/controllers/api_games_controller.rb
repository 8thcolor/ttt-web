class ApiGamesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  before_action :set_saved_game, only: [:play, :show, :destroy]

  def index
    @saved_games = SavedGame.all
  end

  def show
  end

  def play
    @saved_game.game.place(params[:x].to_i, params[:y].to_i)
    
    unless @saved_game.game.finish?
      player = Player.new(@saved_game.game, 1)
      player.play
    end

    @saved_game.data = @saved_game.game.save
    
    if @saved_game.game.winner == -1
      @saved_game.status = 'won'
    elsif @saved_game.game.winner == 1
      @saved_game.status = 'lost'
    end

    @saved_game.save

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
    # Use callbacks to share common setup or constraints between actions.
    def set_saved_game
      @saved_game = SavedGame.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def saved_game_params
      params.require(:saved_game).permit(:data)
    end
end
