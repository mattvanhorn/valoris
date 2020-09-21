defmodule ValorisWeb.LandingPageControllerTest do
  use ValorisWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "A goal properly set is halfway reached."
  end
end
