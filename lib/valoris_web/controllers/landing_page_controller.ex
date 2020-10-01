defmodule ValorisWeb.LandingPageController do
  use ValorisWeb, :controller
  alias Valoris.Goals

  def index(conn, _params) do
    current_user = Pow.Plug.current_user(conn)

    if current_user do
      goals = Goals.list_goals_for_user(current_user)
      focus = Goals.highest_priority(goals)
      goals = List.delete(goals, focus)
      render(conn, "index.html", focus: focus, goals: goals)
    else
      render(conn, "index.html")
    end
  end
end
