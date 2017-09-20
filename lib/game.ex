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

  def deal_initial(player) do
    if length(player.hand) < 4 do
      player = deal_card(player)
      deal_initial(player) 
    else
      player
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
    IO.puts "Its the turn of: " <> inspect Enum.at game.turn,0
    card = IO.gets "which card do you want to play?" |> String.strip
    {card,_} = Integer.parse card
    
    attacker = do_attack game.players[attacker(game)], card
    defender = do_damage game.players[defender(game)], card

    new_players = game.players
    |> Keyword.replace(attacker(game), attacker)
    |> Keyword.replace(defender(game), defender)

    Map.put(game, :players, new_players)
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
end