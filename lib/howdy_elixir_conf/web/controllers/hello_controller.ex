defmodule HowdyElixirConf.Web.HelloController do
  use Spaghetti.PageController

  @person "stranger"
  def index(conn, _params) do
    render(conn, "hello", person: @person)
  end
end
