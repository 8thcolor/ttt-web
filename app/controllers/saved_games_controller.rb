class SavedGamesController < ApplicationController
  before_action :set_saved_game, only: [:win, :lose, :play, :show, :edit, :update, :destroy]

  # GET /saved_games
  # GET /saved_games.json
  def index
    @saved_games = SavedGame.all
  end

  # GET /saved_games/1
  # GET /saved_games/1.json
  def show
  end

  def win
  end

  def lose
  end

  def play
    @game.place(params[:x].to_i, params[:y].to_i)
    @saved_game.data = @game.save
    @saved_game.save

    if @game.winner == -1
      redirect_to action: 'win' and return
    elsif @game.winner == 1
      redirect_to action: 'lose' and return
    end

    player = Player.new(@game, 1)
    player.play

    @saved_game.data = @game.save
    @saved_game.save
    
    if @game.winner == -1
      redirect_to action: 'win' and return
    elsif @game.winner == 1
      redirect_to action: 'lose' and return
    end

    redirect_to action: 'show'
  end

  # GET /saved_games/new
  def new
    @saved_game = SavedGame.new
    game = Game.new(1)
    player = Player.new(game, 1)
    player.play
    
    @saved_game.data = game.save

    respond_to do |format|
      if @saved_game.save
        format.html { redirect_to @saved_game, notice: 'Saved game was successfully created.' }
        format.json { render action: 'show', status: :created, location: @saved_game }
      else
        format.html { render action: 'new' }
        format.json { render json: @saved_game.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /saved_games/1/edit
  def edit
  end

  # POST /saved_games
  # POST /saved_games.json
  def create
    @saved_game = SavedGame.new(saved_game_params)

    respond_to do |format|
      if @saved_game.save
        format.html { redirect_to @saved_game, notice: 'Saved game was successfully created.' }
        format.json { render action: 'show', status: :created, location: @saved_game }
      else
        format.html { render action: 'new' }
        format.json { render json: @saved_game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /saved_games/1
  # PATCH/PUT /saved_games/1.json
  def update
    respond_to do |format|
      if @saved_game.update(saved_game_params)
        format.html { redirect_to @saved_game, notice: 'Saved game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @saved_game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /saved_games/1
  # DELETE /saved_games/1.json
  def destroy
    @saved_game.destroy
    respond_to do |format|
      format.html { redirect_to saved_games_url }
      format.json { head :no_content }
    end
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
