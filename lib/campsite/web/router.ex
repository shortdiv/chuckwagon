defmodule Campsite.Web.Router do
  use Sparrow.Router

  alias Campsite.Web.PageController

  get "/", PageController, :home
  get "/two", PageController, :two
  # get "/hello", HelloController, :index

  get not_matched, PageController, :not_matched, %{path: not_matched}
end
