defmodule WeatherUS.CLI do
  @default_count 2

  @moduledoc """
  Handle the command line parsing and the dispatch to the various functions
  that generate a table for the weather of specific city
  """

  def run(argv) do
    parse_args(argv)
  end

  @doc """
  `argv` can be -h or --help, which returns :help

  otherwise it is a station name.

  return `:station` or `:help` if help was given
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean],
                                     aliases:  [h:    :help])
    case parse do
      { [ help: true ], _ }
      -> :help

      {_, [ station: true ]}
      -> :station

      _ -> :help
    end
  end
end
