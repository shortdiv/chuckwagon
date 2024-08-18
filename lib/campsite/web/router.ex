defmodule Campsite.Web.Router do
  use Spaghetti.Router
  use Spaghetti.PageController

  plug Plugs.Logger, log: :info

  scope "/dev" do
    get "/hello", Campsite.Web.HelloController, :index
    # get "/boop", Campsite.Web.BoopController, :index
  end
end
