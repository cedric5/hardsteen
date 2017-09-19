defmodule Hardsteen do
  
  def start do
      players = [
      Game.deal_initial(%{hand: [], deck: Game.create_deck, id: 0, health: 30}),
      Game.deal_initial(%{hand: [], deck: Game.create_deck, id: 1, health: 30}) 
    ]
    game = %{players: players, turn: 0, state: :playing}

    game = do_turn game

    IO.puts inspect game
  end

  def do_turn(game) do
    game = game |> Game.do_turn |> Game.switch_turn
    case game.state do
      :playing -> do_turn game
      #:done   -> game.finish_game game
    end
  end
end
  