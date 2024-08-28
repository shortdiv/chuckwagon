defmodule HowdyElixirConf.Web.Router do
  use Spaghetti.Router
  use Spaghetti.PageController

  plug Plugs.Logger, log: :info

  scope "/dev" do
    get "/hello", HowdyElixirConf.Web.HelloController, :index
    # get "/boop", HowdyElixirConf.Web.BoopController, :index
  end
end
