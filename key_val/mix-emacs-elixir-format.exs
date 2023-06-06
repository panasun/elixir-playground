defmodule KeyVal.MixProject do
  use Mix.Project

  def project do
    [
      app: :key_val,
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
      mod: {KeyVal.Contractor, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.1.2"},
      {:cubdb, "~> 2.0.2"},
      {:horde, "~> 0.8.7"},
      {:libcluster, "~> 3.3.2"}
    ]
  end
end
