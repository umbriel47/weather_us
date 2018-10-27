defmodule WeatherUS.CLI do

  @moduledoc """
  Handle the command line parsing and the dispatch to the various functions
  that generate a table for the weather of specific city
  """

  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :help

  otherwise it is a station name.

  return `:station` or `:help` if help was given
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean, list: :boolean],
                                     aliases:  [h:    :help, l: :list])
    case parse do
      { [ help: true ], _, _}
      -> :help

      { [ list: true ], _, _}
      -> :list

      {_, [ station ], _}
      -> { station }

      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: weather_us <station>
    """
    System.halt(0)
  end

  def process(:list) do
    WeatherUS.StationObs.fetch_stations()
    |> decode_response
    |> extract_stations
  end

  def process({ station }) do
    #IO.puts "Hello"
    WeatherUS.StationObs.fetch(station)
    |> decode_response
    |> extract_weather
  end

  def decode_response({:ok, body}) do
    body
  end

  def decode_response({:error, error}) do
    {_, message} = List.keyfind(error, "message", 0)
    IO.puts "Error fetching from weather.gov: #{message}"
    System.halt(2)
  end

  def extract_stations(body) do
    IO.puts("extract station list")
  end

  def extract_weather(body) do
    IO.puts "extract weather"
  end

end
