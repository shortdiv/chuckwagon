defmodule Sparrow.PageHandler do
  def init(req, router) do
    path = :cowboy_req.path(req)
    conn = %Plugs.Conn{req_path: path}
    conn = router.call(conn)

    resp =
      :cowboy_req.reply(conn.status, conn.resp_header, conn.resp_body, req)

    {:ok, resp, router}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end
