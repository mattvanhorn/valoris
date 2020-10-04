defmodule ValorisWeb.TaskController do
  use ValorisWeb, :controller

  alias Valoris.Goals
  alias Valoris.Goals.Task

  defp get_goal(%{"goal_id" => goal_id}) do
    Goals.get_goal!(goal_id)
  end

  def index(conn, params) do
    goal = get_goal(params)
    tasks = goal.tasks

    render(conn, "index.html", goal: goal, tasks: tasks)
  end

  def new(conn, params) do
    goal = get_goal(params)
    changeset = Goals.change_task(%Task{goal: goal})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"task" => task_params} = params) do
    goal = get_goal(params)

    case Goals.create_task_for_goal(goal, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: Routes.goal_task_path(conn, :show, goal, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Goals.get_task!(id)
    render(conn, "show.html", task: task)
  end

  def edit(conn, %{"id" => id}) do
    task = Goals.get_task!(id)
    changeset = Goals.change_task(task)
    render(conn, "edit.html", task: task, changeset: changeset)
  end

  def update(conn, %{"id" => id, "task" => task_params} = params) do
    goal = get_goal(params)
    task = Goals.get_task!(id)

    case Goals.update_task(task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: Routes.goal_task_path(conn, :show, goal, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id} = params) do
    goal = get_goal(params)
    task = Goals.get_task!(id)
    {:ok, _task} = Goals.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: Routes.goal_task_path(conn, :index, goal))
  end
end
