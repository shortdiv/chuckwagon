defmodule Sparrow.PageController do
  defmacro __using__(_args) do
    quote do
      def call(conn, action) do
        apply(__MODULE__, action, [conn, "Controller here"])
      end

      def call(conn, action, params) do
        apply(__MODULE__, action, [conn, params])
      end

      def render(conn, template, assigns) do
        view_name = __MODULE__ |> Atom.to_string |> String.replace(~r/Controller$/, "View")
        view_module = Module.concat(Elixir, view_name)
        IO.inspect(view_name)
        IO.inspect(view_module)

        body = view_module.render(template, assigns)
        Plugs.Conn.put_resp_body(conn, body)
      end

      def render(conn, template) do
        IO.puts("is this called?")
        render(conn, template, Enum.to_list(conn.assigns))
      end
      @overridable [call: 2, call: 3, render: 2, render: 3]
    end
  end
end
