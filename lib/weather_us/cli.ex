import WeatherUS.TableFormatter, only: [print_table_for_columns: 2]
import SweetXml

defmodule WeatherUS.CLI do

  @moduledoc """
  Handle the command line parsing and the dispatch to the various functions
  that generate a table for the weather of specific city
  """

  def main(argv) do
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

      { [ list: true], [file_path], _}
      -> {:list, file_path }

      { [ list: true ], _, _}
      -> :list

      {_, [ station ], _}
      -> { station }

      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: weather_us [options]

    OPTIONS:

    -h, --help: display this help
    -l, --list <file_path>: load the station list and display the first 10.
                            If no file_path, the stations will be downloaded
                            online.
    <station name>: display the weather of the given station
    """
    System.halt(0)
  end

  def process({:list, file_path} ) do

    stations = WeatherUS.StationObs.fetch_stations(file_path)
              |> decode_response
              |> extract_stations
    stations1 = Enum.take(stations[:stations], 10)

    IO.inspect stations1

  end

  def process(:list) do
    stations = WeatherUS.StationObs.fetch_stations()
              |> decode_response
              |> extract_stations
    stations1 = Enum.take(stations[:stations], 10)

    IO.inspect stations1
  end

  def process({ station }) do
    #IO.puts "Hello"
    WeatherUS.StationObs.fetch(station)
    |> decode_response
    |> extract_weather
    |> IO.inspect
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

    result = body |> xmap(
      stations: [
        ~x"//station"l,
        id: ~x"./station_id/text()",
        state: ~x"./state/text()",
        station_name: ~x"./station_name/text()",
        latitude: ~x"./latitude/text()",
        longitude: ~x"./longitude/text()",
      ]
    )
  end

  def extract_weather(body) do
    result = body |> xmap(
      location: ~x"//location/text()",
      station: ~x"//station_id/text()",
      latitude: ~x"//latitude/text()",
      longitude: ~x"//longitude/text()",
      observation_time: ~x"//observation_time/text()",
      weather: ~x"//weather/text()",
      temperature: ~x"//temperature_string/text()",
      relative_humidity: ~x"//relative_humidity/text()",
      wind: ~x"//wind_string/text()",
      pressure: ~x"//pressure_string/text()",
      dewpoint: ~x"//dewpoint_string/text()",
      windchill: ~x"//windchill_string/text()",
      visibility: ~x"//visibility_mi/text()"
    )
  end

end
