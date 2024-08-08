defmodule Plugs.Conn do
  defstruct assigns: %{},
            req_path: "",
            resp_header: %{"content-type" => "text/html"},
            resp_body: "",
            status: 200

  def put_resp_body(conn, body) do
    %{conn | resp_body: body}
  end

  def put_status(conn, status) do
    %{conn | status: status}
  end

  def assign(%Plugs.Conn{assigns: assigns} = conn, key, value) do
    %{conn | assigns: Map.put(assigns, key, value)}
  end
end
