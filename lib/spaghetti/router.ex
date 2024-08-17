defmodule Spaghetti.Router do
  defmacro __using__(_opts) do
    quote do
      import Spaghetti.Router
      import Plug.Conn

      def init(opts), do: opts

      def call(conn, _opts) do
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
end
