defmodule Aoc2020.Ferry do
  use Application

  def start(_, _) do
    import Supervisor.Spec, warn: false

    init_seats = []

    children = [
      supervisor(Task.Supervisor, [[name: Aoc2020.Ferry.TaskSupervisor]]),
      worker(Aoc2020.Ferry.FerryServer, [init_seats])
    ]

    opts = [strategy: :one_for_one, name: Aoc2020.Ferry.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
