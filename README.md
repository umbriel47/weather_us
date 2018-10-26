# WeatherUs

WeatherUS extract information from  https://w1.weather.gov/xml/current_obs/<station>.xml and provide a search function to display the weather information for the city of your interest. All station index is obtained from https://w1.weather.gov/xml/current_obs/index.xml. After each inquiry, the weather information of the requested state will be downloaded from weather.gov if it is not downloaded yet (the data is updated every hour).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `weather_us` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:weather_us, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/weather_us](https://hexdocs.pm/weather_us).
