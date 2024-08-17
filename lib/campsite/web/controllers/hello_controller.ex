defmodule Campsite.Web.HelloController do
  use Spaghetti.PageController

  @message "hello"
  def index(conn, _params) do
    render(conn, "hello", message: @message)
  end
end
