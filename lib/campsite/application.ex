defmodule Campsite.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    start_cowboy()
    children = [
      # Starts a worker by calling: Campsite.Worker.start_link(arg)
      # {Campsite.Worker, arg}
    ]

    opts = [strategy: :one_for_one, name: Campsite.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def start_cowboy do
    route1 = {:_, Campsite.Web.PageHandler, Campsite.Web.Router}

    dispatch = :cowboy_router.compile([
      {:_, [
        route1
      ]}
    ])

    case :cowboy.start_clear(
      :hello_http,
      [port: 4000],
      %{env: %{dispatch: dispatch}}) do

    {:ok, _something} ->
      IO.puts("works")

    _ ->
      IO.puts("error starting cowboy server")
    end
  end
end
