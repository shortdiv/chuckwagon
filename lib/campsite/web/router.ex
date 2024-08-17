defmodule Campsite.Web.Router do
  use Spaghetti.Router
  use Spaghetti.PageController

  plug Plugs.Logger, log: :info

  get "/hello", Campsite.Web.HelloController, :index
end
