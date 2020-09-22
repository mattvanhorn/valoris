defmodule ValorisWeb.LandingPageController do
  use ValorisWeb, :controller
  alias Valoris.Goals

  def index(conn, _params) do
    goals = Goals.list_goals()
    focus = Goals.highest_priority(goals)
    goals = List.delete(goals, focus)
    render(conn, "index.html", focus: focus, goals: goals)
  end
end
