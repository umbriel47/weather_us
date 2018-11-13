defmodule WeatherUS.StationObs do

  require Logger

  @user_agent [{"User-agent", "Umbriel umbriel@infplus.com"}]
  @weather_url Application.get_env(:weather_us, :weather_url)
  @list_url Application.get_env(:weather_us, :list_url)

  @doc """
  Fetch the weather information from a station, given the station name
  """
  def fetch(station) do
    Logger.info "Fetching station info with #{station}"
    xml_url(station)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  @doc """
  Get the list of top-10 stations from the website
  """
  def fetch_stations() do
    Logger.info "Fetching station list"
    @list_url
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  @doc """
  Get the list of stations from a local file
  """
  def fetch_stations(file) do
    File.read(file)
  end

  @doc """
  Return the url for the xml file to get the station list
  """
  def xml_url(station) do
    "#{@weather_url}/#{station}.xml"
  end

  def handle_response({_, %{status_code: 200, body: body}}) do
    Logger.info "Successful response"
    Logger.debug fn -> inspect(body) end
    {:ok, body}
  end

  def handle_response({_, %{status_code: status, body: body}}) do
    Logger.error "Error #{status} returned"
    {:error, body}
  end
end
