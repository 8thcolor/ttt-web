class MailGamesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def index
    @saved_games = SavedGame.all
  end

  def play
    message = JSON.parse(request.body.read)
    title = message["Subject"]
    body = message["TextBody"]

    id = /TTTGame-(\d+)\s/.match(title)[1].to_i

    first_line = body.lines.first
    x = first_line[0].to_i
    y = first_line[2].to_i

    @saved_game = SavedGame.find(id)
    @saved_game.play_turn(x, y)

    status = @saved_game.status
    body_contents = "TTTGame-#{id} is #{status} - your move!\n Grid: \n #{@saved_game.grid_s}\n Play by replying to this mail."
    
    message = Mail.new do
      from            'you.from@mail.com'
      reply_to        "postmarkinbound@inbound.postmarkapp.com"
      to              'you.to@mail.com'
      subject         "TTTGame-#{id} is #{status}!"
      body            body_contents

      delivery_method Mail::Postmark, :api_key => ENV['POSTMARK_API_KEY']
    end

    message.deliver

    render status: 200
  end

  def new
    @saved_game = SavedGame.new
    @saved_game.status = 'ongoing'
    
    game = Game.new(1)
    player = Player.new(game, 1)
    player.play

    @saved_game.data = game.save
    @saved_game.save

    id = @saved_game.id
    body_contents = "TTTGame-#{id} has just started - your move!\n Grid: \n #{@saved_game.grid_s}\n Play by replying to this mail."

    message = Mail.new do
      from            'you.from@mail.com'
      reply_to        "postmarkinbound@inbound.postmarkapp.com"
      to              'you.to@mail.com'
      subject         "TTTGame-#{id} has started!"
      body            body_contents

      delivery_method Mail::Postmark, :api_key => ENV['POSTMARK_API_KEY']
    end

    message.deliver

    redirect_to action: 'index', notice: 'Game started !'
  end

end
