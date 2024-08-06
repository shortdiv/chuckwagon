defmodule Campsite.Web.PageHandler do
  def init(req, _opts) do
    resp =
      :cowboy_req.reply(200, %{"content-type" => "text/html"}, "<!doctype html><h1>Hello World!</h1>", req)

    {:ok, resp, []}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end
