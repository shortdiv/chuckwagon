defmodule Campsite.Web.Router do
  use Spaghetti.Router

  plug Plugs.Logger, log: :info

  get "/hello" do
    send_resp(conn, 200, "world")
  end
end
