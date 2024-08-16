defmodule Giddyup do
  @moduledoc """
  Adapter for Cowboy2
  """

  @doc false
  def start(_type, _args) do
    Supervisor.start_link([], strategy: :one_for_one)
  end

  def args(scheme, plug, plug_opts, _opts) do
    optt = plug.init(plug_opts)
    dispatch_for = [{:_, [{:_, Giddyup.Handler, {plug, optt}}]}]

    dispatch = :cowboy_router.compile(dispatch_for)
    protocol_options = Map.merge(%{env: %{dispatch: dispatch}}, %{})
    socket_options = [
      {:ip, {127, 0, 0, 1}},
      {:port, 4000},
      {:backlog, 1024}
    ]
    transport_options =
      []
      |> Keyword.put_new(:num_acceptors, 100)
      |> Keyword.put_new(:max_connections, 16_384)
      |> Keyword.update(
        :socket_opts,
        socket_options,
        &(&1 ++ socket_options)
      )
      |> Map.new()

    ref = Module.concat(plug, scheme |> to_string |> String.upcase())

    [ref, transport_options, protocol_options]
  end

  @doc false
  def child_spec(opts) do
    {plug, plug_opts} =
      case Keyword.fetch!(opts, :plug) do
        {_, _} = tuple -> tuple
        plug -> {plug, []}
      end

    cowboy_opts = Keyword.get(opts, :options, []) #[port: 4000]
    cowboy_args = args(:http, plug, plug_opts, cowboy_opts)
    [ref, transport_opts, proto_opts] = cowboy_args
    {ranch_module, cowboy_protocol, transport_opts} =
      {:ranch_tcp, :cowboy_clear, transport_opts}

    case :ranch.child_spec(ref, ranch_module, transport_opts, cowboy_protocol, proto_opts) do
      {id, start, restart, shutdown, type, modules} ->
        %{
          id: id,
          start: start,
          restart: restart,
          shutdown: shutdown,
          type: type,
          modules: modules
        }

      child_spec when is_map(child_spec) ->
        child_spec
    end
  end

  def dispatch(plug) do
    :cowboy_router.compile([
      {:_, [{:_, Giddyup.Handler, {plug, []}}]}
    ])
  end
end
