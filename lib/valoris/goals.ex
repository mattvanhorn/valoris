defmodule Valoris.Goals do
  @moduledoc """
  The Goals context.
  """

  import Ecto.Query, warn: false
  alias Valoris.Repo

  alias Valoris.Goals.Goal
  alias Valoris.Accounts.User
  alias Valoris.Progress

  def highest_priority(goals) do
    goals
    |> Enum.sort_by(fn g -> comparable_datetime(most_recent_change(g)) end)
    |> Enum.at(0)
  end

  defp most_recent_change(goal) do
    action = Progress.most_recent_action(goal)
    (action && action.inserted_at) || goal.inserted_at
  end

  # This is necessary because Render only supports Elixir 1.9.4
  # So we don't have the new sorting conveniences for dates/times
  defp comparable_datetime(datetime) do
    {datetime.year, datetime.month, datetime.day, datetime.hour, datetime.minute, datetime.second}
  end

  @doc """
  Returns the list of goals.

  ## Examples

      iex> list_goals()
      [%Goal{}, ...]

  """
  def list_goals do
    Repo.all(Goal)
  end

  def list_goals_for_user(%User{id: user_id}) do
    list_goals_for_user(user_id)
  end

  def list_goals_for_user(user_id) do
    Goal
    |> where([g], g.user_id == ^user_id)
    |> Repo.all()
  end

  @doc """
  Gets a single goal.

  Raises `Ecto.NoResultsError` if the Goal does not exist.

  ## Examples

      iex> get_goal!(123)
      %Goal{}

      iex> get_goal!(456)
      ** (Ecto.NoResultsError)

  """
  def get_goal!(id), do: Repo.get!(Goal, id)

  @doc """
  Creates a goal.

  ## Examples

      iex> create_goal(%{field: value})
      {:ok, %Goal{}}

      iex> create_goal(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_goal(attrs \\ %{}) do
    %Goal{}
    |> Goal.changeset(attrs)
    |> Repo.insert()
  end

  def create_goal_for_user(%User{} = user, attrs \\ %{}) do
    %Goal{user_id: user.id}
    |> Goal.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a goal.

  ## Examples

      iex> update_goal(goal, %{field: new_value})
      {:ok, %Goal{}}

      iex> update_goal(goal, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_goal(%Goal{} = goal, attrs) do
    goal
    |> Goal.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a goal.

  ## Examples

      iex> delete_goal(goal)
      {:ok, %Goal{}}

      iex> delete_goal(goal)
      {:error, %Ecto.Changeset{}}

  """
  def delete_goal(%Goal{} = goal) do
    Repo.delete(goal)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking goal changes.

  ## Examples

      iex> change_goal(goal)
      %Ecto.Changeset{data: %Goal{}}

  """
  def change_goal(%Goal{} = goal, attrs \\ %{}) do
    Goal.changeset(goal, attrs)
  end
end
