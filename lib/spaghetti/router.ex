defmodule Spaghetti.Router do
  defmacro __using__(_opts) do
    quote do
      require Logger

      import Spaghetti.Router
      import Plug.Conn
      import Plug

      @before_compile Spaghetti.Router

      @prefix ""
      @plugs []
      @scope_path []
      @routes []
      Module.register_attribute(__MODULE__, :routes, accumulate: true)

      import unquote(__MODULE__)
      @before_compile unquote(__MODULE__)

      def init(opts), do: opts

      def call(conn, _opts) do
        conn = apply_plugs(conn)

        dispatch(conn.method, conn.request_path, conn)
      end

      defp dispatch(method, path, conn) do
        # sneaky way to get routes at runtime, for some reason @routes is empty on runtime
        routes = __routes__()

        method = String.downcase(method) |> String.to_existing_atom()
        case Enum.find(routes, fn {m, p, _, _, _} -> m == method and p == path end) do
          {_method, _path, controller, action, opts} ->
            apply(controller, action, [conn, opts])
          nil -> conn |> send_resp(404, "Not found")
        end
      end
    end
  end

  # {:__block__, [], [{:get, [line: 9, column: 5], ["/hello", {:__aliases__, [line: 9, column: 19], [:HowdyElixirConf, :Web, :HelloController]}, :index]}, {:get, [line: 10, column: 5], ["/boop", {:__aliases__, [line: 10, column: 18], [:HowdyElixirConf, :Web, :BoopController]}, :index]}]}
  defmacro scope(prefix, do: block) do
    quote do
      previous_scope = @scope_path
      @scope_path [@scope_path, unquote(prefix)] |> List.flatten |> Enum.join("/") |> String.replace("//", "/")
      @prefix unquote(prefix)
      unquote(block)
      @scope_path previous_scope
    end
  end

  defmacro get(path, controller, action, opts \\ []) do
    quote do
      path_with_prefix = Path.join(@prefix || "", unquote(path))

      @routes {:get, path_with_prefix, unquote(controller), unquote(action), unquote(opts)}
      @routes
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

      # Sneaky way to get runtime access to routes since Module.get_attribute(__MODULE__, :routes) is only accessible at compile time
      def __routes__ do
        @routes
      end

      defp apply_plugs(conn) do
        Enum.reduce(@plugs, conn, fn {plug, opts}, acc ->
          apply(plug, :call, [acc, opts])
        end)
      end
    end
  end
end
