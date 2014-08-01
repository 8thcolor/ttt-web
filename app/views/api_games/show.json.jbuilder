json.extract! @saved_game, :id, :status, :created_at, :updated_at

@list = @saved_game.game.board

json.grid do
  json.array!(@list)  
end
