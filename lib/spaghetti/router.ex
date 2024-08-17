defmodule Spaghetti.Router do
  defmacro __using__(_opts) do
    quote do
      require Logger

      import Spaghetti.Router
      import Plug.Conn
      import Plug

      @before_compile Spaghetti.Router
      @plugs []
      @routes []
      Module.register_attribute(__MODULE__, :routes, accumulate: true)

      def init(opts), do: opts

      def call(conn, _opts) do
        IO.puts("calliung")
        conn = apply_plugs(conn)

        # content_for(conn.request_path, conn)
        dispatch(conn.method, conn.request_path, conn)
      end

      defp dispatch(method, path, conn) do
        routes = @routes
        IO.puts("routing things I think?")
        case Enum.find(@routes, fn {m, p, _, _} -> m == String.downcase(method) and p == path end) do
          {_,_, handler} ->
            IO.inspect(handler)
            IO.puts("what is this")
            handler.(conn)
          nil -> conn |> send_resp(404, "Not found")
        end
      end
    end
  end

  # block is like this before the quote and then it borks
  # {:__block__, [], [{:get, [line: 9, column: 5], ["/hello", {:__aliases__, [line: 9, column: 19], [:Campsite, :Web, :HelloController]}, :index]}, {:get, [line: 10, column: 5], ["/boop", {:__aliases__, [line: 10, column: 18], [:Campsite, :Web, :BoopController]}, :index]}]}
  defmacro scope(prefix, do: block) do
    IO.inspect(block)
    quote do
      IO.puts("wjhfiwegyforw")
      @prefix unquote(prefix)
      IO.inspect(unquote(block))
      IO.puts("hey")
      unquote(block)
    end
  end

  defmacro get(path, controller, action) do
    quote do
      path_with_prefix = Path.join(@prefix || "", unquote(path))

      handler = fn conn ->
        apply(unquote(controller), unquote(action), [conn])
      end

      @routes [{:get, path_with_prefix, handler} | @routes]
    end
  end

  defmacro match(do: block) do
    quote do
      unquote(block)
    end
  end

  defmacro plug(plug_name, opts \\ []) do
    quote do
      @plugs [{unquote(plug_name), unquote(opts)} | @plugs]
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      # Spaghetti.Router.match do
      #   Plug.Conn.resp(conn, 404, "oops")
      # end

      defp apply_plugs(conn) do
        Enum.reduce(@plugs, conn, fn {plug, opts}, acc ->
          apply(plug, :call, [acc, opts])
        end)
      end
    end
  end
end
