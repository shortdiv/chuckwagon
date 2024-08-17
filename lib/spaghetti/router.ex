defmodule Spaghetti.Router do
  defmacro __using__(_opts) do
    quote do
      import Spaghetti.Router
      import Plug.Conn
      import Plug

      @before_compile Spaghetti.Router
      @plugs []

      def init(opts), do: opts

      def call(conn, _opts) do
        conn = apply_plugs(conn)
        content_for(conn.request_path, conn)
      end
    end
  end

  defmacro get(path, do: block) do
    quote do
      defp content_for(unquote(path), var!(conn)) do
        unquote(block)
      end
    end
  end

  defmacro match(do: block) do
    quote do
      defp content_for(_, var!(conn)) do
        unquote(block)
      end
    end
  end

  defmacro plug(plug_name, opts) do
    quote do
      @plugs [{unquote(plug_name), unquote(opts)} | @plugs]
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      defp apply_plugs(conn) do
        Enum.reduce(@plugs, conn, fn {plug, opts}, acc ->
          apply(plug, :call, [acc, opts])
        end)
      end
    end
  end
end
