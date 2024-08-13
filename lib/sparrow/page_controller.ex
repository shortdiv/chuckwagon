defmodule Sparrow.PageController do
  defmacro __using__(_args) do
    quote do
      def call(conn, action) do
        apply(__MODULE__, action, [conn, "Controller here"])
      end

      def call(conn, action, params) do
        apply(__MODULE__, action, [conn, params])
      end

      def render(conn, name, assigns) do
        inner_content = EEx.eval_file("lib/campsite/web/views/#{name}_view.eex", assigns)
        assigns = assigns ++ [{:inner_content, inner_content}]

        body = try do
          EEx.eval_file("lib/campsite/web/templates/layouts/root.eex", assigns)
        rescue
          e in CompileError -> IO.inspect(e)
        end
        Plugs.Conn.put_resp_body(conn, body)
      end

      def render(conn, template) do
        render(conn, template, Enum.to_list(conn.assigns))
      end
      @overridable [call: 2, call: 3, render: 2, render: 3]
    end
  end
end
