defmodule Sparrow.PageController do
  @unsent [:unset, :set, :set_chunked, :set_file]

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
        IO.puts("this???")
        IO.inspect(conn)
        # Plugs.Conn.put_resp_body(conn, body)
        # conn
        #   |> Plug.Conn.(body)
        #   |> Plug.Conn.put_status(:ok)  # Setting the response status to 200
        # |> put_view(MyAppWeb.SpecialView)
      end

      def render(conn, template) do
        render(conn, template, Enum.to_list(conn.assigns))
      end
      @overridable [call: 2, call: 3, render: 2, render: 3]

      # def put_view(%Plug.Conn{state: state} = conn, formats) when state in unquote(@unsent) do
      #   %{conn | private: Map.put(conn.private, :phoenix_view, view_module)}
      #   # put_private_view(conn, :phoenix_view, :replace, formats)
      # end

      # def put_view(%Plug.Conn{}, _module), do: raise(AlreadySentError)
      # defp put_private_view(conn, priv_key, kind, formats) when is_list(formats) do
      #   formats = Enum.into(formats, %{}, fn {format, value} -> {to_string(format), value} end)
      #   put_private_formats(conn, priv_key, kind, formats)
      # end
      # defp put_private_formats(conn, priv_key, kind, formats) when kind in [:new, :replace] do
      #   update_in(conn.private, fn private ->
      #     existing = private[priv_key] || %{}

      #     new_formats =
      #       case kind do
      #         :new -> Map.merge(formats, existing)
      #         :replace -> Map.merge(existing, formats)
      #       end

      #     Map.put(private, priv_key, new_formats)
      #   end)
      # end
    end
  end
end
