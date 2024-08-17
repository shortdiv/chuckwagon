defmodule Spaghetti.PageController do
  require Logger
  defmacro __using__(_args) do
    quote do
      def call(conn, action) do
        apply(__MODULE__, action, [conn, ""])
      end

      def call(conn, action, params) do
        apply(__MODULE__, action, [conn, params])
      end

      def render(conn, template, assigns) do
        view_name = __MODULE__
                    |> Module.split()
                    |> Enum.join(".")
                    |> String.replace(~r/Controller$/, "View")

        module = Module.concat(Elixir, view_name)
        module.render(conn, template, assigns)
      end

      def render(conn, template) do
        render(conn, template, Enum.to_list(conn.assigns))
      end
      @overriddable [call: 2, call: 3, render: 2, render: 3]
    end
  end
end
