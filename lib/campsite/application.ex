defmodule Campsite.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # start_cowboy()
    children = [
      {Giddyup, plug: Campsite.Web.Router, scheme: :http, options: [port: 4000]}
    ]

    opts = [strategy: :one_for_one, name: Campsite.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # def start_cowboy do
  #   routes = [
  #     {:_, Sparrow.PageHandler, Campsite.Web.Router}
  #   ]

  #   dispatch = :cowboy_router.compile([
  #     {:_, routes}
  #   ])

  #   case :cowboy.start_clear(
  #     :hello_http,
  #     [port: 4000],
  #     %{env: %{dispatch: dispatch}}) do

  #   {:ok, _something} ->
  #     IO.puts("Running cowboy on port 4000")

  #   _ ->
  #     IO.puts("error starting cowboy server")
  #   end
  # end
end
