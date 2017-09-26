defmodule Game do
  def create_deck do
    deck = [0,0,1,1,2,2,2,3,3,3,3,4,4,4,5,5,6,6,7,8]
    Enum.shuffle deck
  end

  def attacker(game) do
    Enum.at(game.turn, 0)
  end

  def defender(game) do
    Enum.at(game.turn, 1)
  end

  def create_player(player_stub) do
    if length(player_stub.hand) < 3 do
      player_stub = deal_card(player_stub)
      create_player(player_stub)
    else
      player_stub
    end
  end

  def deal_card(player) do
    [head | tail] = player.deck
    player
    |> Map.put(:deck, tail)
    |> Map.put(:hand, player.hand ++ [head])
  end

  def do_turn(game) do
    attacker = game.players[attacker(game)]
               |> deal_card
               |> increase_mana
               |> print_status

    defender = game.players[defender(game)]

    card = ask_card(attacker)

    new_players = game.players
    |> Keyword.replace(attacker(game), do_attack(attacker, card))
    |> Keyword.replace(defender(game), do_damage(defender, card))

    Map.put(game, :players, new_players)
  end

  def print_status(player) do
    IO.puts "Its the turn of: #{player.name}"
    IO.puts "your hand contains: #{inspect player.hand}"
    IO.puts "you have #{player.mana} mana to spend this turn"
    player
  end

  def increase_mana(player) do
    player |> Map.put(:mana, player.mana + 1)
  end

  def ask_card(player) do
    input = IO.gets("which card do you want to play? (-1 for none) ") |> Integer.parse
    case input do
      :error    -> ask_card(player)
      {-1, _}   -> nil
      {card, _} -> if(valid?(card, player), do: card, else: ask_card(player))
    end
  end

  def valid?(card, player) do
    Enum.member?(player.hand, card) && card <= player.mana
  end

  def do_attack(player, card) do
    if card == nil do
      player
    else
      player |> Map.put(:hand, player.hand |> List.delete(card))
    end
  end

  def do_damage(player, hit) do
    if hit == nil do
      player
    else
      player |> Map.put(:health, player.health - hit)
    end
  end

  def switch_turn(game) do
    case game.turn do
      [:p1, :p2] -> Map.put(game, :turn, [:p2, :p1])
      [:p2, :p1] -> Map.put(game, :turn, [:p1, :p2])
    end
  end

  def check_state(game) do
    if any_dead?(game.players) do
      game |> Map.put(:state, :done)
    else
      game |> Map.put(:state, :playing)
    end
  end

  def any_dead?(players) do
    players
    |> Keyword.values
    |> Enum.map(&(&1.health))
    |> Enum.any?(&(&1 <= 0))
  end
end
