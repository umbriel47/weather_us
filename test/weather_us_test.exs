defmodule WeatherUsTest do
  use ExUnit.Case
  doctest WeatherUs

  test "greets the world" do
    assert WeatherUs.hello() == :world
  end
end
