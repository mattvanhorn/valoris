defmodule ValorisWeb.LandingPageController do
  use ValorisWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
