defmodule Dallas.MixProject do
  use Mix.Project

  def project do
    [
      app: :dallas,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Dallas.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.6.0"},
      # {:phoenix_ecto, "~> 4.1"},
      # {:ecto_sql, "~> 3.4"},
      # {:postgrex, ">= 0.0.0"},
      {:phoenix_live_view, "~> 0.17.1"},
      {:floki, ">= 0.27.0", only: :test},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 0.5"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      {:esbuild, "~> 0.2", runtime: Mix.env() == :dev},
      {:dart_sass, "~> 0.3", runtime: Mix.env() == :dev}
    ]
    |> Enum.concat(instrument_deps())
  end

  defp instrument_deps do
    [
      {:tzdata, "~> 1.1"},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "esbuild.install", "sass.install"],
      "assets.deploy": [
        "esbuild default --minify",
        "sass default --no-source-map --style=compressed",
        "phx.digest",
      ],
    ]
  end
end
