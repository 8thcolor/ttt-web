json.array!(@saved_games) do |saved_game|
  json.extract! saved_game, :id, :data, :status
  json.url api_game_url(saved_game, format: :json)
end
