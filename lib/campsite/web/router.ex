defmodule Campsite.Web.Router do
  use Sparrow.Router
  # import Plugs.Conn

  alias Campsite.Web.PageController

  get "/", PageController, :home
  get "/2", PageController, :two

  get not_matched, PageController, :not_matched, %{path: not_matched}
end
