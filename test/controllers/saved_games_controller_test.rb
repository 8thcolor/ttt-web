require 'test_helper'

class SavedGamesControllerTest < ActionController::TestCase
  setup do
    @saved_game = saved_games(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:saved_games)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create saved_game" do
    assert_difference('SavedGame.count') do
      post :create, saved_game: { data: @saved_game.data }
    end

    assert_redirected_to saved_game_path(assigns(:saved_game))
  end

  test "should show saved_game" do
    get :show, id: @saved_game
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @saved_game
    assert_response :success
  end

  test "should update saved_game" do
    patch :update, id: @saved_game, saved_game: { data: @saved_game.data }
    assert_redirected_to saved_game_path(assigns(:saved_game))
  end

  test "should destroy saved_game" do
    assert_difference('SavedGame.count', -1) do
      delete :destroy, id: @saved_game
    end

    assert_redirected_to saved_games_path
  end
end
