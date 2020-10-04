defmodule ValorisWeb.PracticeController do
  use ValorisWeb, :controller

  alias Valoris.Goals
  alias Valoris.Goals.Practice

  defp get_goal(%{"goal_id" => goal_id}) do
    Goals.get_goal!(goal_id)
  end

  def index(conn, params) do
    goal = get_goal(params)
    practices = goal.practices

    render(conn, "index.html", goal: goal, practices: practices)
  end

  def new(conn, params) do
    goal = get_goal(params)
    changeset = Goals.change_practice(%Practice{goal: goal})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"practice" => practice_params} = params) do
    goal = get_goal(params)

    case Goals.create_practice_for_goal(goal, practice_params) do
      {:ok, practice} ->
        conn
        |> put_flash(:info, "Practice created successfully.")
        |> redirect(to: Routes.goal_practice_path(conn, :show, goal, practice))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    practice = Goals.get_practice!(id)
    render(conn, "show.html", practice: practice)
  end

  def edit(conn, %{"id" => id}) do
    practice = Goals.get_practice!(id)
    changeset = Goals.change_practice(practice)
    render(conn, "edit.html", practice: practice, changeset: changeset)
  end

  def update(conn, %{"id" => id, "practice" => practice_params} = params) do
    goal = get_goal(params)
    practice = Goals.get_practice!(id)

    case Goals.update_practice(practice, practice_params) do
      {:ok, practice} ->
        conn
        |> put_flash(:info, "Practice updated successfully.")
        |> redirect(to: Routes.goal_practice_path(conn, :show, goal, practice))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", practice: practice, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id} = params) do
    goal = get_goal(params)
    practice = Goals.get_practice!(id)
    {:ok, _practice} = Goals.delete_practice(practice)

    conn
    |> put_flash(:info, "Practice deleted successfully.")
    |> redirect(to: Routes.goal_practice_path(conn, :index, goal))
  end
end
