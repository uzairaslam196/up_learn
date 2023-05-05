defmodule UpLearn.MixProject do
  use Mix.Project

  def project do
    [
      app: :up_learn,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 2.1"},
      {:floki, "~> 0.34.2"},
      {:mox, "~> 1.0.0", only: [:dev, :test]}
    ]
  end
end
