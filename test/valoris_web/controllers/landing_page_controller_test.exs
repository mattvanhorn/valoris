defmodule ValorisWeb.LandingPageControllerTest do
  use ValorisWeb.ConnCase
  alias Valoris.Accounts.User
  alias Valoris.Goals

  setup %{conn: conn} do
    user = %User{email: "test@example.com", id: 42}
    authed_conn = Pow.Plug.assign_current_user(conn, user, otp_app: :valoris)
    {:ok, conn: conn, authed_conn: authed_conn}
  end

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "A goal properly set is halfway reached."
  end

  test "GET / lists current goals", %{authed_conn: authed_conn} do
    {:ok, _goal} =
      Goals.create_goal(%{
        user_id: authed_conn.assigns.current_user.id,
        name: "example goal name",
        purpose: "example purpose"
      })

    conn = get(authed_conn, "/")
    assert html_response(conn, 200) =~ "example goal name"
  end
end
