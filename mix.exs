defmodule WeatherUs.MixProject do
  use Mix.Project

  def project do
    [
      app: :weather_us,
      version: "0.1.0",
      name: "WeatherUS",
      source_url: "https://github.com/umbriel/weather_us",
      elixir: "~> 1.6",
      escript: escript_config,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpoison]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.4"},
      {:sweet_xml, "~> 0.6.5"},
      {:ex_doc, github: "elixir-lang/ex_doc"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end

  defp escript_config do
    [ main_module: WeatherUS.CLI ]
  end

end
