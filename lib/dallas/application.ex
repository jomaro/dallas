defmodule Dallas.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @data [
    %Dallas.Measurement{
      path: "test",
      level: :ok,
      value: 0,
      instrument: Test,
      execution_date: DateTime.utc_now()
    },
    %Dallas.Measurement{
      path: "test_folder/ok",
      level: :ok,
      value: 0,
      instrument: Test,
      execution_date: DateTime.utc_now()
    },
    %Dallas.Measurement{
      path: "test_folder/error",
      level: :error,
      value: 500,
      instrument: Test,
      execution_date: DateTime.utc_now()
    },
    %Dallas.Measurement{
      path: "test_folder/warning",
      level: :warning,
      value: 100,
      instrument: Test,
      execution_date: DateTime.utc_now()
    },
  ]

  @impl true
  def start(_type, _args) do
    queues = Application.get_env(:dallas, :queues, [default: 1])

    children = [
      # Starts a worker by calling: Dallas.Worker.start_link(arg)
      # {Dallas.Worker, arg}
      {Dallas.SchedulerSupervisor, queues},
      {Dallas.ResultSet, @data}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dallas.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
