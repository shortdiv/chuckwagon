defmodule Campsite.Web.Router do
  use Spaghetti.Router

  get "/hello" do
    send_resp(conn, 200, "world")
  end

  match do
    send_resp(conn, 404, "oops")
  end
end
