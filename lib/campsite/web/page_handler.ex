defmodule Campsite.Web.PageHandler do
  def init(req, state) do
    resp =
      :cowboy_req.reply(200, %{"content-type" => "text/html"}, content_for(state), req)

    {:ok, resp, []}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end

  def content_for(:base) do
    "<h1>This is the base content</h1>"
  end

  def content_for(:base2) do
    "<h1>This is the second base</h1>"
  end
end
