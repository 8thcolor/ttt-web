TicTacToe - Rails Application
=============================

Rails application allowing to play TicTacToe game against a (drunk) computer.

Built as an show of different kinds of User Interfaces, as part as a talk given at [Paris.rb](https://speakerdeck.com/vanakenm/ive-an-idea-lets-do-a-webapp-or-not).

Also check the [logic part](http://github.com/vanakenm/ttt) and the [command line client](http://github.com/vanakenm/ttt-cmd).

# How to run

    bundle install
    rake db:migrate
    rails s

Note that the "mail" interface does not works locally (see below).

# Interfaces

## Web
Basic web interface (implemented in SavedGamesController). Default, standard stuff.

## API
Sample JSON based "REST" interface (implementedin APIGamesController). Can be easily tested using any REST client (I use Postman in Chrome).

* Start a new game: POST /api_games
* Play: POST /api_games/:id/play (with x & y specified)

## Mail
Use the web interface to start a game (could be started by sending a mail, did not had time to do it that way.). Play by replying to the emails with the coordinate of your next move separated by a single space:

    0 1

# How to deploy

## Heroku basics
This is created to be deployed on Heroku, using heroku getting started procedure (nothing weird). 

https://devcenter.heroku.com/articles/getting-started-with-rails4

## Postmark
To be able to use the "mail" interface, you need to add Postmark to your application following those instructions:

https://devcenter.heroku.com/articles/postmark

You'll need a sender signature and also check the "Using Postmark Inbound" section (to be able to receive the emails).

You also need to modify the values of the from, to and reply to emails in MailGamesController:

    from            'you.from@mail.com'
    reply_to        'postmarkinbound@inbound.postmarkapp.com'
    to              'you.to@mail.com'

The reply to should be the postmark inbound address (that you can get using your postmark account.)