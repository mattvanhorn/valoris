defmodule ValorisWeb.TaskControllerTest do
  use ValorisWeb.ConnCase

  alias Valoris.Accounts.User
  alias Valoris.Goals

  @create_attrs %{index: 42, name: "some name"}
  @update_attrs %{index: 43, name: "some updated name"}
  @invalid_attrs %{index: nil, name: nil}

  def fixture(:goal) do
    {:ok, goal} = Goals.create_goal(%{name: "foo", purpose: "bar"})
    goal
  end

  def fixture(:task) do
    {:ok, task} = Goals.create_task_for_goal(fixture(:goal), @create_attrs)
    task
  end

  setup %{conn: conn} do
    user = %User{email: "test@example.com", id: 42}
    authed_conn = Pow.Plug.assign_current_user(conn, user, otp_app: :valoris)
    {:ok, conn: conn, authed_conn: authed_conn}
  end

  describe "index" do
    test "lists all tasks", %{authed_conn: conn} do
      conn = get(conn, Routes.goal_task_path(conn, :index, fixture(:goal)))
      assert html_response(conn, 200) =~ "Listing Tasks"
    end
  end

  describe "new task" do
    test "renders form", %{authed_conn: conn} do
      conn = get(conn, Routes.goal_task_path(conn, :new, fixture(:goal)))
      assert html_response(conn, 200) =~ "New Task"
    end
  end

  describe "create task" do
    test "redirects to show when data is valid", %{authed_conn: authed_conn} do
      goal = fixture(:goal)

      conn =
        post(authed_conn, Routes.goal_task_path(authed_conn, :create, goal), task: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.goal_task_path(conn, :show, goal, id)

      conn = get(authed_conn, Routes.goal_task_path(authed_conn, :show, goal, id))
      assert html_response(conn, 200) =~ "Show Task"
    end

    test "renders errors when data is invalid", %{authed_conn: conn} do
      conn =
        post(conn, Routes.goal_task_path(conn, :create, fixture(:goal)), task: @invalid_attrs)

      assert html_response(conn, 200) =~ "New Task"
    end
  end

  describe "edit task" do
    setup [:create_task]

    test "renders form for editing chosen task", %{authed_conn: conn, task: task} do
      conn = get(conn, Routes.goal_task_path(conn, :edit, task.goal, task))
      assert html_response(conn, 200) =~ "Edit Task"
    end
  end

  describe "update task" do
    setup [:create_task]

    test "redirects when data is valid", %{authed_conn: authed_conn, task: task} do
      conn =
        put(authed_conn, Routes.goal_task_path(authed_conn, :update, task.goal, task),
          task: @update_attrs
        )

      assert redirected_to(conn) == Routes.goal_task_path(conn, :show, task.goal, task)

      conn = get(authed_conn, Routes.goal_task_path(authed_conn, :show, task.goal, task))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{authed_conn: conn, task: task} do
      conn =
        put(conn, Routes.goal_task_path(conn, :update, task.goal, task), task: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Task"
    end
  end

  describe "delete task" do
    setup [:create_task]

    test "deletes chosen task", %{authed_conn: authed_conn, task: task} do
      conn = delete(authed_conn, Routes.goal_task_path(authed_conn, :delete, task.goal, task))
      assert redirected_to(conn) == Routes.goal_task_path(conn, :index, task.goal)

      assert_error_sent 404, fn ->
        get(authed_conn, Routes.goal_task_path(authed_conn, :show, task.goal, task))
      end
    end
  end

  defp create_task(_) do
    task = fixture(:task)
    %{task: task}
  end
end
