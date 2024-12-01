defmodule Dallas.SchedulerSupervisor do
  use Supervisor

  alias Dallas.Scheduler

  def start_link(queues) do
    Supervisor.start_link(__MODULE__, queues, name: __MODULE__)
  end

  @impl true
  def init(queues) do
    queues
    |> Enum.map(fn spec = {queue, _concurrency} -> Supervisor.child_spec({Scheduler, spec}, id: Module.concat(Scheduler, queue)) end)
    |> Supervisor.init(strategy: :one_for_one)
  end
end
