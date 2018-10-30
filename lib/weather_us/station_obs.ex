defmodule WeatherUS.StationObs do
  @user_agent [{"User-agent", "Umbriel umbriel@infplus.com"}]
  @weather_url Application.get_env(:weather_us, :weather_url)
  @list_url Application.get_env(:weather_us, :list_url)

  def fetch(station) do
    xml_url(station)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def fetch_stations() do
    @list_url
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def fetch_stations(file) do
    File.read(file)
  end

  def xml_url(station) do
    "#{@weather_url}/#{station}.xml"
  end

  def handle_response({_, %{status_code: 200, body: body}}), do: {:ok, body}
  def handle_response({_, %{status_code: ___, body: body}}), do: {:error, body}
end
