defmodule Dallas.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    queues = Application.get_env(:dallas, :queues, default: 1)

    children = [
      # Starts a worker by calling: Dallas.Worker.start_link(arg)
      # {Dallas.Worker, arg}
      {Dallas.SchedulerSupervisor, queues},
      Dallas.ResultSet
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dallas.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
