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
    attacker = deal_card game.players[attacker(game)]

    card = ask_card(attacker)

    attacker = do_attack attacker, card
    defender = do_damage game.players[defender(game)], card

    new_players = game.players
    |> Keyword.replace(attacker(game), attacker)
    |> Keyword.replace(defender(game), defender)

    Map.put(game, :players, new_players)
  end

  def ask_card(player) do
    IO.puts "Its the turn of: #{player.name}"
    IO.puts "your hand contains: #{inspect player.hand}"
    card = IO.gets "which card do you want to play? " |> String.trim
    {card,_} = Integer.parse card
    card
  end


  def do_attack(player, card) do
    new_hand = List.delete(player.hand, card)
    Map.put(player, :hand, new_hand)
  end

  def do_damage(player, hit) do
    new_health = player.health - hit
    Map.put(player, :health, new_health)
  end

  def switch_turn(game) do
    case game.turn do
      [:p1, :p2] -> Map.put(game, :turn, [:p2, :p1])
      [:p2, :p1] -> Map.put(game, :turn, [:p1, :p2])
    end
  end

  def check_state(game) do
    if game.players |> Keyword.values |> Enum.any?(&(&1.health <= 0)) do
      Map.put(game, :state, :done)
    else
      Map.put(game, :state, :playing)
    end
  end
end
