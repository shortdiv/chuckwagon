defmodule Campsite.Web.PageHandler do
  def init(req, _state) do
    path = :cowboy_req.path(req)
    resp =
      :cowboy_req.reply(200, %{"content-type" => "text/html"}, content_for(path), req)

    {:ok, resp, []}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end

  def content_for("/") do
    "<h1>This is the base content</h1>"
  end

  def content_for("/2") do
    "<h1>This is the second base</h1>"
  end
end
