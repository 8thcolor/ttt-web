class SavedGamesController < ApplicationController
  before_action :set_saved_game, only: [:play, :show, :destroy]

  def index
    @saved_games = SavedGame.all
  end

  def show
  end

  def play
    @game.place(params[:x].to_i, params[:y].to_i)
    
    unless @game.finish?
      player = Player.new(@game, 1)
      player.play
    end

    @saved_game.data = @game.save
    
    if @game.winner == -1
      @saved_game.status = 'won'
    elsif @game.winner == 1
      @saved_game.status = 'lost'
    end

    @saved_game.save

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

    message = Mail.new do
      from            'martin.vanaken@8thcolor.com'
      to              'vanakenm@gmail.com'
      subject         "TTT Game #{@saved_game.id} has started!"
      body            "TTT Game #{@saved_game.id} has started!"

      delivery_method Mail::Postmark, :api_key => ENV['POSTMARK_API_KEY']
    end

    message.deliver

    redirect_to @saved_game, notice: 'Saved game was successfully created.'
  end

  def destroy
    @saved_game.destroy
    redirect_to saved_games_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_saved_game
      @saved_game = SavedGame.find(params[:id])
      @game = Game::load(@saved_game.data)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def saved_game_params
      params.require(:saved_game).permit(:data)
    end
end
