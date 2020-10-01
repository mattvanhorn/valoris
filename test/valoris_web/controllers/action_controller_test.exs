defmodule ValorisWeb.ActionControllerTest do
  use ValorisWeb.ConnCase

  alias Valoris.Accounts.User
  alias Valoris.Progress

  @create_attrs %{description: "some description", title: "some title"}
  @update_attrs %{description: "some updated description", title: "some updated title"}
  @invalid_attrs %{description: nil, title: nil}

  def fixture(:action) do
    {:ok, action} = Progress.create_action(@create_attrs)
    action
  end

  setup %{conn: conn} do
    user = %User{email: "test@example.com", id: 42}
    authed_conn = Pow.Plug.assign_current_user(conn, user, otp_app: :valoris)
    {:ok, conn: conn, authed_conn: authed_conn}
  end

  describe "index" do
    test "lists all actions", %{authed_conn: authed_conn} do
      conn = get(authed_conn, Routes.action_path(authed_conn, :index))
      assert html_response(conn, 200) =~ "Listing Actions"
    end
  end

  describe "new action" do
    test "renders form", %{authed_conn: authed_conn} do
      conn = get(authed_conn, Routes.action_path(authed_conn, :new))
      assert html_response(conn, 200) =~ "New Action"
    end
  end

  describe "create action" do
    test "redirects to show when data is valid", %{authed_conn: authed_conn} do
      conn = post(authed_conn, Routes.action_path(authed_conn, :create), action: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.action_path(conn, :show, id)

      conn = get(authed_conn, Routes.action_path(authed_conn, :show, id))
      assert html_response(conn, 200) =~ "Show Action"
    end

    test "renders errors when data is invalid", %{authed_conn: authed_conn} do
      conn = post(authed_conn, Routes.action_path(authed_conn, :create), action: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Action"
    end
  end

  describe "edit action" do
    setup [:create_action]

    test "renders form for editing chosen action", %{authed_conn: authed_conn, action: action} do
      conn = get(authed_conn, Routes.action_path(authed_conn, :edit, action))
      assert html_response(conn, 200) =~ "Edit Action"
    end
  end

  describe "update action" do
    setup [:create_action]

    test "redirects when data is valid", %{authed_conn: authed_conn, action: action} do
      conn =
        put(authed_conn, Routes.action_path(authed_conn, :update, action), action: @update_attrs)

      assert redirected_to(conn) == Routes.action_path(conn, :show, action)

      conn = get(authed_conn, Routes.action_path(authed_conn, :show, action))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{authed_conn: authed_conn, action: action} do
      conn =
        put(authed_conn, Routes.action_path(authed_conn, :update, action), action: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Action"
    end
  end

  describe "delete action" do
    setup [:create_action]

    test "deletes chosen action", %{authed_conn: authed_conn, action: action} do
      conn = delete(authed_conn, Routes.action_path(authed_conn, :delete, action))
      assert redirected_to(conn) == Routes.action_path(conn, :index)

      assert_error_sent 404, fn ->
        get(authed_conn, Routes.action_path(authed_conn, :show, action))
      end
    end
  end

  defp create_action(_) do
    action = fixture(:action)
    %{action: action}
  end
end
