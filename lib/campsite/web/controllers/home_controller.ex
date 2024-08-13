defmodule Campsite.Web.HomeController do
  use Sparrow.PageController

  # any and all assigns happen here!
  @camp_counselors [
    %{name: "Divya"}
  ]

  def index(conn, _params) do
    render(conn, "home", counselors: @camp_counselors)
  end
end
