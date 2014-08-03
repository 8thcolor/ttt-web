class MailGamesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def index
    @saved_games = SavedGame.all
  end

  def show
  end

  def play
    message = JSON.parse(request.body.read)
    title = message["Subject"]
    body = message["TextBody"]

    id = /TTTGame-(\d+)\s/.match(title)[1].to_i

    @saved_game = SavedGame.find(id)
    @game = Game::load(@saved_game.data)

    first_line = body.lines.first
    x = first_line[0]
    y = first_line[2]

    @game.place(x.to_i, y.to_i)
    
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

    status = @saved_game.status
    body_contents = "TTTGame-#{id} is #{status} - your move!\n Grid: #{game.save}\n Play by replying to this mail."
    
    message = Mail.new do
      from            'martin.vanaken@8thcolor.com'
      reply_to        "6d2ae99a2eb04e1b420df399c0f60e98@inbound.postmarkapp.com"
      to              'vanakenm@gmail.com'
      subject         "TTTGame-#{id} is #{status}!"
      body            body_contents

      delivery_method Mail::Postmark, :api_key => ENV['POSTMARK_API_KEY']
    end

    message.deliver
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
    body_contents = "TTTGame-#{id} has just started - your move!\n Grid: #{game.save}\n Play by replying to this mail."

    message = Mail.new do
      from            'martin.vanaken@8thcolor.com'
      reply_to        "6d2ae99a2eb04e1b420df399c0f60e98@inbound.postmarkapp.com"
      to              'vanakenm@gmail.com'
      subject         "TTTGame-#{id} has started!"
      body            body_contents

      delivery_method Mail::Postmark, :api_key => ENV['POSTMARK_API_KEY']
    end

    message.deliver

    redirect_to action: 'index', notice: 'Game started !'
  end

end
