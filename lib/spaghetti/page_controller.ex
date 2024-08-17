defmodule Spaghetti.PageController do
  require Logger
  defmacro __using__(_args) do
    quote do
      def call(conn, action) do
        IO.puts("here first?")
        apply(__MODULE__, action, [conn, ""])
      end

      def call(conn, action, params) do
        IO.puts("or here?")
        apply(__MODULE__, action, [conn, params])
      end

      def render(conn, template, assigns) do
        IO.puts("does it ever get here?")
        view_name = __MODULE__
                    |> Module.split()
                    |> Enum.join(".")
                    |> String.replace(~r/Controller$/, "View")

        module = Module.concat(Elixir, view_name)

        if get_module_status(module) do
          module.render(conn, template, assigns)
        else
          Plug.Conn.resp(conn, 404, "Error view not found")
        end
      end

      defp get_module_status(module_name) when is_atom(module_name) do
        Code.ensure_loaded?(module_name)
      end

      def render(conn, template) do
        render(conn, template, Enum.to_list(conn.assigns))
      end
      @overriddable [call: 2, call: 3, render: 2, render: 3]
    end
  end
end
