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
    parse = OptionParser.parse(argv, switches: [help: :boolean, list: :boolean,
                                                state: :boolean, name: :boolean],
                                     aliases:  [h:    :help, l: :list,
                                                s: :state, n: :name])
    case parse do
      { [ help: true ], _, _}
      -> :help

      { [ list: true], [file_path], _}
      -> {:list, file_path }

      { [ list: true ], _, _}
      -> :list

      { [ state: true], [ state ], _}
      -> {:state, state}

      { [name: true], [ station ], _}
      -> { :name, station }

      _ -> :help
    end
  end

  @doc """
  Process the --help argument
  """
  def process(:help) do
    IO.puts """
    usage: weather_us [options]

    OPTIONS:

    -h, --help: display this help
    -l, --list <file_path>: load the station list and display the first 10.
                            If no file_path, the stations will be downloaded
                            online.
    -s, --state <state name>: list all the stations within a state
    -n, --name <station name>: display the weather of the given station

    """
    System.halt(0)
  end

  @doc """
  Process the --list argument with a file path. It loads the station list
  from the file and display them
  """
  def process({:list, file_path} ) do

    stations = WeatherUS.StationObs.fetch_stations(file_path)
              |> decode_response
              |> extract_stations
    stations1 = Enum.take(stations[:stations], 10)

    IO.inspect stations1

  end

  @doc """
  Process the --list argument when a file path is absent. It fetches the
  station list from the website and display them.
  """
  def process(:list) do
    stations = WeatherUS.StationObs.fetch_stations()
              |> decode_response
              |> extract_stations
    stations1 = Enum.take(stations[:stations], 10)

    IO.inspect stations1
  end

  def process({ :state, state }) do
    # list all the stations within the given state
    stations = WeatherUS.StationObs.fetch_stations("./data/index.xml")
              |> decode_response
              |> extract_stations
    stations_for_state = extract_stations_for_state(stations[:stations], state)
  end

  @doc """
  Process the --name argument with a station name.
  returns: the weather at the given station
  """
  def process({ :name, station }) do
    #IO.puts "Hello"
    WeatherUS.StationObs.fetch(station)
    |> decode_response
    |> extract_weather
    |> IO.inspect
  end

  @doc """
  return: the body when the fetcher succeed
  """
  def decode_response({:ok, body}) do
    body
  end

  @doc """
  return: the error message when the fetcher fails
  """
  def decode_response({:error, error}) do
    {_, message} = List.keyfind(error, "message", 0)
    IO.puts "Error fetching from weather.gov: #{message}"
    System.halt(2)
  end

  @doc """
  Extract the station information from the fetched list xml file
  """
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

  @doc """
  Extract the station list with a given state name
  """
  def extract_stations_for_state(stations, state) do
    for sta = %{ state: state_name } <- stations,
        List.to_string(state_name) == state do
          IO.inspect sta
        end
  end

  @doc """
  Extract the weather with the xml returned from a given station
  """
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
