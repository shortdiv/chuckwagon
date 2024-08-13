defmodule Campsite.Web.Router do
  use Sparrow.Router
  import Sparrow.PageController

  get "/", Campsite.Web.HomeController, :index
  get "/two", Campsite.Web.PageController, :two

  get not_matched, Campsite.Web.PageController, :not_matched, %{path: not_matched}
end
