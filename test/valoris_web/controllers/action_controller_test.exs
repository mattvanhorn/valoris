defmodule ValorisWeb.ActionControllerTest do
  use ValorisWeb.ConnCase

  alias Valoris.Accounts.User
  alias Valoris.Goals
  alias Valoris.Progress

  @create_attrs %{description: "some description", title: "some title"}
  @update_attrs %{description: "some updated description", title: "some updated title"}
  @invalid_attrs %{description: nil, title: nil}

  def fixture(:goal) do
    {:ok, goal} = Goals.create_goal(%{name: "foo", purpose: "bar"})
    goal
  end

  def fixture(:action) do
    {:ok, action} =
      Progress.create_action(Map.merge(@create_attrs, %{goal_id: fixture(:goal).id}))

    action |> Valoris.Repo.preload(:goal)
  end

  setup %{conn: conn} do
    user = %User{email: "test@example.com", id: 42}
    authed_conn = Pow.Plug.assign_current_user(conn, user, otp_app: :valoris)
    {:ok, conn: conn, authed_conn: authed_conn}
  end

  describe "index" do
    test "lists all actions", %{authed_conn: authed_conn} do
      conn = get(authed_conn, Routes.goal_action_path(authed_conn, :index, fixture(:goal)))
      assert html_response(conn, 200) =~ "Listing Actions"
    end
  end

  describe "new action" do
    test "renders form", %{authed_conn: authed_conn} do
      conn = get(authed_conn, Routes.goal_action_path(authed_conn, :new, fixture(:goal)))
      assert html_response(conn, 200) =~ "New Action"
    end
  end

  describe "create action" do
    test "redirects to show when data is valid", %{authed_conn: authed_conn} do
      goal = fixture(:goal)

      conn =
        post(authed_conn, Routes.goal_action_path(authed_conn, :create, goal),
          action: @create_attrs
        )

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.goal_action_path(conn, :show, goal, id)

      conn = get(authed_conn, Routes.goal_action_path(authed_conn, :show, goal, id))
      assert html_response(conn, 200) =~ "Show Action"
    end

    test "renders errors when data is invalid", %{authed_conn: authed_conn} do
      conn =
        post(authed_conn, Routes.goal_action_path(authed_conn, :create, fixture(:goal)),
          action: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "New Action"
    end
  end

  describe "edit action" do
    setup [:create_action]

    test "renders form for editing chosen action", %{
      authed_conn: authed_conn,
      action: action
    } do
      conn = get(authed_conn, Routes.goal_action_path(authed_conn, :edit, action.goal, action))
      assert html_response(conn, 200) =~ "Edit Action"
    end
  end

  describe "update action" do
    setup [:create_action]

    test "redirects when data is valid", %{authed_conn: authed_conn, action: action} do
      conn =
        put(authed_conn, Routes.goal_action_path(authed_conn, :update, action.goal, action),
          action: @update_attrs
        )

      assert redirected_to(conn) == Routes.goal_action_path(conn, :show, action.goal, action)

      conn = get(authed_conn, Routes.goal_action_path(authed_conn, :show, action.goal, action))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{
      authed_conn: authed_conn,
      action: action
    } do
      conn =
        put(authed_conn, Routes.goal_action_path(authed_conn, :update, action.goal, action),
          action: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Action"
    end
  end

  describe "delete action" do
    setup [:create_action]

    test "deletes chosen action", %{authed_conn: authed_conn, action: action} do
      conn =
        delete(authed_conn, Routes.goal_action_path(authed_conn, :delete, action.goal, action))

      assert redirected_to(conn) == Routes.landing_page_path(conn, :index)

      assert_error_sent 404, fn ->
        get(authed_conn, Routes.goal_action_path(authed_conn, :show, action.goal, action))
      end
    end
  end

  defp create_action(_conn) do
    action = fixture(:action)
    %{action: action}
  end
end
