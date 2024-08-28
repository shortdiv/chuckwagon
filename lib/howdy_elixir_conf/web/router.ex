defmodule HowdyElixirConf.Web.Router do
  use Spaghetti.Router
  # import Plugs.Conn

  alias HowdyElixirConf.Web.PageController

  get "/", PageController, :home
  get "/2", PageController, :two

  get not_matched, PageController, :not_matched, %{path: not_matched}
end
