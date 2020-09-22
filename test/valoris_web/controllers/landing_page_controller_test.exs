defmodule ValorisWeb.LandingPageControllerTest do
  use ValorisWeb.ConnCase
  alias Valoris.Goals

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "A goal properly set is halfway reached."
  end

  test "GET / lists current goals", %{conn: conn} do
    {:ok, _goal} = Goals.create_goal(%{name: "example goal name", purpose: "example purpose"})
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "example goal name"
  end
end
