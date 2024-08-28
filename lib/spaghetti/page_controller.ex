defmodule Spaghetti.PageController do
  defmacro __using__(_args) do
    quote do
      def call(conn, action) do
        apply(__MODULE__, action, [conn, "Controller here"])
      end

      def call(conn, action, params) do
        apply(__MODULE__, action, [conn, params])
      end
      def overridable [call: 2, call: 3]
    end
  end
end
