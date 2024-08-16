defmodule Plugs.Logger do
  require Logger
  @behaviour Plug

  def init(opts), do: opts

  def call(conn, [log: lvl] = _level) do
    Plug.Conn.register_before_send(conn, fn conn ->
      start = System.monotonic_time()
      status_message = case conn.status do
        200 ->
          "🚀 Success!"
        404 ->
          "😞 Failed!"
      end
      Logger.log(lvl, fn ->
        stop = System.monotonic_time()
        diff = System.convert_time_unit(stop - start, :native, :microsecond)
        status = Integer.to_string(conn.status)
        "#{status_message} Sent #{status} to #{conn.request_path} in #{diff} µs"
      end)
      conn
    end)
  end
end
