defmodule Hardsteen do
  
  def start do
      players = [
      p1: Game.deal_initial(%{hand: [], deck: Game.create_deck, id: 0, health: 30}),
      p2: Game.deal_initial(%{hand: [], deck: Game.create_deck, id: 1, health: 30}) 
    ]
    game = %{players: players, turn: [:p1, :p2], state: :playing}
    game = do_turn game
  end

  def do_turn(game) do
    IO.puts "----------------"
    IO.puts inspect game.turn
    IO.puts "player_1: #{inspect game.players[:p1]}"
    IO.puts "player_2: #{inspect game.players[:p2]}" 
    IO.puts "----------------"  
    game = Game.do_turn game
    game = Game.switch_turn game
    case game.state do
      :playing -> do_turn game
      #:done   -> game.finish_game game
    end
  end
end
  