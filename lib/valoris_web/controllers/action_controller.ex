defmodule ValorisWeb.ActionController do
  use ValorisWeb, :controller

  alias Valoris.Progress
  alias Valoris.Progress.Action

  def index(conn, _params) do
    actions = Progress.list_actions()
    render(conn, "index.html", actions: actions)
  end

  defp fetch_goal(params) do
    if params["goal_id"], do: Valoris.Goals.get_goal!(params["goal_id"]), else: nil
  end

  def new(conn, params) do
    goal = fetch_goal(params)
    changeset = Progress.change_action(%Action{})
    render(conn, "new.html", changeset: changeset, goal: goal)
  end

  def create(conn, params = %{"action" => action_params}) do
    goal = fetch_goal(params)

    action_params = if goal, do: Map.put(action_params, "goal_id", goal.id), else: action_params

    case Progress.create_action(action_params) do
      {:ok, action} ->
        conn
        |> put_flash(:info, "Action created successfully.")
        |> redirect(
          to:
            if goal do
              Routes.goal_action_path(conn, :show, goal, action)
            else
              Routes.action_path(conn, :show, action)
            end
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, goal: goal)
    end
  end

  def show(conn, %{"id" => id}) do
    action = Progress.get_action!(id)
    render(conn, "show.html", action: action)
  end

  def edit(conn, %{"id" => id}) do
    action = Progress.get_action!(id)
    changeset = Progress.change_action(action)
    render(conn, "edit.html", action: action, changeset: changeset)
  end

  def update(conn, %{"id" => id, "action" => action_params}) do
    action = Progress.get_action!(id)

    case Progress.update_action(action, action_params) do
      {:ok, action} ->
        conn
        |> put_flash(:info, "Action updated successfully.")
        |> redirect(to: Routes.action_path(conn, :show, action))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", action: action, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    action = Progress.get_action!(id)
    {:ok, _action} = Progress.delete_action(action)

    conn
    |> put_flash(:info, "Action deleted successfully.")
    |> redirect(to: Routes.action_path(conn, :index))
  end
end
