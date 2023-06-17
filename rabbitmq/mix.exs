defmodule Rabbitmq.MixProject do
  use Mix.Project

  def project do
    [
      app: :rabbitmq,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mode: {Rabbitmq.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:broadway, "~> 1.0"},
      {:broadway_rabbitmq, "~> 0.8.0"},
      {:broadway_kafka, "~> 0.3"}
    ]
  end
end
