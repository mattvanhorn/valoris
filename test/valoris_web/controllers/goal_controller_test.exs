defmodule ValorisWeb.GoalControllerTest do
  use ValorisWeb.ConnCase

  alias Valoris.Accounts.User
  alias Valoris.Goals

  @create_attrs %{name: "some name", purpose: "some purpose"}
  @update_attrs %{name: "some updated name", purpose: "some updated purpose"}
  @invalid_attrs %{name: nil, purpose: nil}

  def fixture(:goal) do
    {:ok, goal} = Goals.create_goal(@create_attrs)
    goal
  end

  setup %{conn: conn} do
    user = %User{email: "test@example.com", id: 42}
    authed_conn = Pow.Plug.assign_current_user(conn, user, otp_app: :valoris)
    {:ok, conn: conn, authed_conn: authed_conn}
  end

  describe "index" do
    test "lists all goals", %{authed_conn: authed_conn} do
      conn = get(authed_conn, Routes.goal_path(authed_conn, :index))
      assert html_response(conn, 200) =~ "Listing Goals"
    end
  end

  describe "new goal" do
    test "renders form", %{authed_conn: authed_conn} do
      authed_conn = get(authed_conn, Routes.goal_path(authed_conn, :new))
      assert html_response(authed_conn, 200) =~ "New Goal"
    end
  end

  describe "create goal" do
    test "redirects to show when data is valid", %{conn: conn, authed_conn: authed_conn} do
      conn = post(authed_conn, Routes.goal_path(conn, :create), goal: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.goal_path(conn, :show, id)

      conn = get(authed_conn, Routes.goal_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Goal"
    end

    test "renders errors when data is invalid", %{authed_conn: authed_conn} do
      authed_conn =
        post(authed_conn, Routes.goal_path(authed_conn, :create), goal: @invalid_attrs)

      assert html_response(authed_conn, 200) =~ "New Goal"
    end
  end

  describe "edit goal" do
    setup [:create_goal]

    test "renders form for editing chosen goal", %{authed_conn: authed_conn, goal: goal} do
      conn = get(authed_conn, Routes.goal_path(authed_conn, :edit, goal))
      assert html_response(conn, 200) =~ "Edit Goal"
    end
  end

  describe "update goal" do
    setup [:create_goal]

    test "redirects when data is valid", %{authed_conn: authed_conn, goal: goal} do
      conn = put(authed_conn, Routes.goal_path(authed_conn, :update, goal), goal: @update_attrs)
      assert redirected_to(conn) == Routes.goal_path(authed_conn, :show, goal)

      conn = get(authed_conn, Routes.goal_path(authed_conn, :show, goal))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{authed_conn: authed_conn, goal: goal} do
      conn = put(authed_conn, Routes.goal_path(authed_conn, :update, goal), goal: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Goal"
    end
  end

  describe "delete goal" do
    setup [:create_goal]

    test "deletes chosen goal", %{authed_conn: authed_conn, goal: goal} do
      conn = delete(authed_conn, Routes.goal_path(authed_conn, :delete, goal))
      assert redirected_to(conn) == Routes.goal_path(conn, :index)

      assert_error_sent 404, fn ->
        get(authed_conn, Routes.goal_path(authed_conn, :show, goal))
      end
    end
  end

  defp create_goal(_) do
    goal = fixture(:goal)
    %{goal: goal}
  end
end
