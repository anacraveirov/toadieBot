defmodule ToadieBot.Application do
  use Application

  def start(_type, _args) do
    children = [
      ToadieBot.Consumer
    ]

    opts = [strategy: :one_for_one, name: ToadieBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end