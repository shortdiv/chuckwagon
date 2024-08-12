defmodule Campsite.Web.HomeController do
  use Sparrow.PageController

  def index(conn, _params) do
    render(conn, "home", [])
  end
end
