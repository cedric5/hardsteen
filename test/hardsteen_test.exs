defmodule HardsteenTest do
  use ExUnit.Case
  doctest Hardsteen

  test "greets the world" do
    assert Hardsteen.hello() == :world
  end
end
