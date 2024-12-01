defmodule DallasTest do
  use ExUnit.Case
  doctest Dallas

  test "greets the world" do
    assert Dallas.hello() == :world
  end
end
