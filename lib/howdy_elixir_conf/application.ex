defmodule HowdyElixirConf.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Giddyup, plug: HowdyElixirConf.Web.Router, scheme: :http, options: [port: 4000]}
    ]

    opts = [strategy: :one_for_one, name: HowdyElixirConf.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
