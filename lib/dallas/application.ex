defmodule Dallas.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      # Dallas.Repo,
      # Start the Telemetry supervisor
      DallasWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Dallas.PubSub},
      # Start the Endpoint (http/https)
      DallasWeb.Endpoint,
      # Start a worker by calling: Dallas.Worker.start_link(arg)
      # {Dallas.Worker, arg}

      Dallas.ResultSet,

      Dallas.StateChangeBroker,

      get_children(),
    ]
    |> List.flatten()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dallas.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp get_children() do
    [
      Supervisor.child_spec({Dallas.Executor, instrument_type: :general, workers: 4}, id: :executor_general),
      Supervisor.child_spec({Dallas.Executor, instrument_type: :tz, workers: 4}, id: :executor_tz),
    ]
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DallasWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
