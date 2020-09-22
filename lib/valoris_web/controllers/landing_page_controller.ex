defmodule ValorisWeb.LandingPageController do
  use ValorisWeb, :controller
  alias Valoris.Goals

  def index(conn, _params) do
    goals = Goals.list_goals()
    render(conn, "index.html", goals: goals)
  end
end
