defmodule Campsite.Web.Router do
  use Sparrow.Router
  # import Plugs.Conn

  alias Campsite.Web.PageController

  get "/", PageController, :home
  # def call(conn) do
  #   content_for(conn.req_path, conn)
  # end

  # defp content_for("/", conn) do
  #   conn |> Campsite.Web.PageController.call(:home)
  # end

  # defp content_for("/2", conn) do
  #   conn |> Campsite.Web.PageController.call(:two)
  # end

  # defp content_for(_, conn) do
  #   conn |> Campsite.Web.PageController.call(:not_matched)
  # end
end
