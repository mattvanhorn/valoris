defmodule Valoris.Progress do
  @moduledoc """
  The Progress context.
  """

  import Ecto.Query, warn: false
  alias Valoris.Repo

  alias Valoris.Goals.Goal
  alias Valoris.Progress.Action

  @doc """
  Returns the most recent action for a Goal.
  """
  def most_recent_action(%Goal{} = goal) do
    goal =
      Repo.preload(
        goal,
        actions:
          from(
            a in Action,
            order_by: [desc: a.inserted_at],
            limit: 1
          )
      )

    goal.actions
    |> Enum.at(0)
  end

  @doc """
  Returns the list of actions.

  ## Examples

      iex> list_actions()
      [%Action{}, ...]

  """
  def list_actions do
    Action
    |> preload(:goal)
    |> Repo.all()
  end

  @doc """
  Gets a single action.

  Raises `Ecto.NoResultsError` if the Action does not exist.

  ## Examples

      iex> get_action!(123)
      %Action{}

      iex> get_action!(456)
      ** (Ecto.NoResultsError)

  """
  def get_action!(id) do
    Action
    |> Repo.get!(id)
    |> Repo.preload(:goal)
  end

  @doc """
  Creates a action.

  ## Examples

      iex> create_action(%{field: value})
      {:ok, %Action{}}

      iex> create_action(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_action(attrs \\ %{}) do
    %Action{}
    |> Action.changeset(attrs)
    |> Repo.insert()
  end

  def create_action_for_goal(goal, attrs \\ %{}) do
    %Action{goal: goal}
    |> Action.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a action.

  ## Examples

      iex> update_action(action, %{field: new_value})
      {:ok, %Action{}}

      iex> update_action(action, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_action(%Action{} = action, attrs) do
    action
    |> Action.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a action.

  ## Examples

      iex> delete_action(action)
      {:ok, %Action{}}

      iex> delete_action(action)
      {:error, %Ecto.Changeset{}}

  """
  def delete_action(%Action{} = action) do
    Repo.delete(action)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking action changes.

  ## Examples

      iex> change_action(action)
      %Ecto.Changeset{data: %Action{}}

  """
  def change_action(%Action{} = action, attrs \\ %{}) do
    Action.changeset(action, attrs)
  end
end
