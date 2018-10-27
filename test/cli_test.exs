defmodule CliTest do
  use ExUnit.Case

  import WeatherUS.CLI, only: [ parse_args: 1 ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test ":list returned by option parsing with -l and --list options" do
    assert parse_args(["-l", "anything"]) == :list
    assert parse_args(["--list", "anythin"]) == :list
  end

  test "station name returned if one is given" do
    assert parse_args(["station"]) == {"station"}
  end
end
