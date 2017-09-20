defmodule Hardsteen do
  def start do
    players = [
      p1: Game.create_player(%{hand: [], deck: Game.create_deck, name: :p1, health: 10}),
      p2: Game.create_player(%{hand: [], deck: Game.create_deck, name: :p2, health: 10})
    ]
    game = %{players: players, turn: [:p1, :p2], state: :playing}
    do_turn game, game.state
  end

  def do_turn(game, :playing) do
    game.players
    |> Keyword.values
    |> Enum.map(&("#{&1.name}: ❤️ : #{&1.health} "))
    |> print_status

    game
    |> Game.do_turn
    |> Game.switch_turn
    |> Game.check_state
    |> do_turn(game.state)

  end

  def do_turn(_, :done) do
    IO.puts "done!"
  end

  def print_status(health) do
    IO.puts "-----------------------------"
    IO.puts "status: #{health}"
  end
end
