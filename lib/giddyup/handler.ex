defmodule Giddyup.Handler do
  @connection Giddyup.Conn
  @already_sent {:plug_conn, :sent}

  def init(req, {plug, opts}) do
    conn = @connection.conn(req)
    IO.puts("here? is this running")

    try do
      conn
      |> plug.call(opts)
      |> send_connection(plug)
      |> case do
        %Plug.Conn{adapter: {@connection, %{upgrade: {:websocket, websocket_args}} = req}} = conn ->
          {handler, state, cowboy_opts} = websocket_args
          {__MODULE__, copy_resp_headers(conn, req), {handler, state}, cowboy_opts}

        %Plug.Conn{adapter: {@connection, req}} ->
          {:ok, req, {plug, opts}}
      end
    catch
      kind, reason ->
        exit_on_error(kind, reason, __STACKTRACE__, {plug, :call, [conn, opts]})
    after
      receive do
        @already_sent -> :ok
      after
        0 -> :ok
      end
    end
  end

  defp send_connection(%Plug.Conn{state: :set} = conn, _plug) do
    Plug.Conn.send_resp(conn)
  end
  defp send_connection(%Plug.Conn{} = conn, _plug) do
    conn
  end

  defp copy_resp_headers(%Plug.Conn{} = conn, req) do
    Enum.reduce(conn.resp_headers, req, fn {key, val}, acc ->
      :cowboy_req.set_resp_header(key, val, acc)
    end)
  end

  defp exit_on_error(
    :error,
    %Plug.Conn.WrapperError{kind: kind, reason: reason, stack: stack},
    _stack,
    call
  ) do
exit_on_error(kind, reason, stack, call)
end

defp exit_on_error(:error, value, stack, call) do
exception = Exception.normalize(:error, value, stack)
:erlang.raise(:exit, {{exception, stack}, call}, [])
end

defp exit_on_error(:throw, value, stack, call) do
:erlang.raise(:exit, {{{:nocatch, value}, stack}, call}, [])
end

defp exit_on_error(:exit, value, _stack, call) do
:erlang.raise(:exit, {value, call}, [])
end
end
