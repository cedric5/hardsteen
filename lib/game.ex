defmodule Game do
  def create_deck do
    hand = [0,0,1,1,2,2,2,3,3,3,3,4,4,4,5,5,6,6,7,8]  
    Enum.shuffle hand   
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
    player = Map.put(player,:deck, tail)
    player = Map.put(player,:hand, player.hand ++ [head])
  end

  def do_turn(game) do
      current_player = Enum.find game.players, fn player ->
        player.id == game.turn
      end
      do_play game current_player
    end

  def do_play(game, current_player) do
    card = IO.gets 'which card do you want to play?'

  end

  def switch_turn(game) do
    case game.turn do
      0 -> Map.put(game, :turn, 1)
      1 -> Map.put(game, :turn, 0)
    end
  end
end