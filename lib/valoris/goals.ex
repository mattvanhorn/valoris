defmodule Valoris.Goals do
  @moduledoc """
  The Goals context.
  """

  import Ecto.Query, warn: false

  alias Valoris.Repo
  alias Valoris.Accounts.User
  alias Valoris.Goals.{Goal, Task, Practice}
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
    Goal
    |> preload([:tasks, :actions, :practices])
    |> Repo.all()
  end

  def list_goals_for_user(%User{id: user_id}) do
    list_goals_for_user(user_id)
  end

  def list_goals_for_user(user_id) do
    Goal
    |> where([g], g.user_id == ^user_id)
    |> preload([:tasks, :actions, :practices])
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
  def get_goal!(id) do
    Goal
    |> preload([:tasks, :actions, :practices])
    |> Repo.get!(id)
  end

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

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Task
    |> preload(:goal)
    |> Repo.all()
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id) do
    Task
    |> preload(:goal)
    |> Repo.get!(id)
  end

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  def create_task_for_goal(goal, attrs \\ %{}) do
    %Task{goal: goal}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  @doc """
  Returns the list of practices.

  ## Examples

      iex> list_practices()
      [%Practice{}, ...]

  """
  def list_practices do
    Repo.all(Practice)
  end

  @doc """
  Gets a single practice.

  Raises `Ecto.NoResultsError` if the Practice does not exist.

  ## Examples

      iex> get_practice!(123)
      %Practice{}

      iex> get_practice!(456)
      ** (Ecto.NoResultsError)

  """
  def get_practice!(id) do
    Practice
    |> preload(:goal)
    |> Repo.get!(id)
  end

  @doc """
  Creates a practice.

  ## Examples

      iex> create_practice(%{field: value})
      {:ok, %Practice{}}

      iex> create_practice(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_practice(attrs \\ %{}) do
    %Practice{}
    |> Practice.changeset(attrs)
    |> Repo.insert()
  end

  def create_practice_for_goal(goal, attrs \\ %{}) do
    %Practice{goal: goal}
    |> Practice.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a practice.

  ## Examples

      iex> update_practice(practice, %{field: new_value})
      {:ok, %Practice{}}

      iex> update_practice(practice, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_practice(%Practice{} = practice, attrs) do
    practice
    |> Practice.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a practice.

  ## Examples

      iex> delete_practice(practice)
      {:ok, %Practice{}}

      iex> delete_practice(practice)
      {:error, %Ecto.Changeset{}}

  """
  def delete_practice(%Practice{} = practice) do
    Repo.delete(practice)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking practice changes.

  ## Examples

      iex> change_practice(practice)
      %Ecto.Changeset{data: %Practice{}}

  """
  def change_practice(%Practice{} = practice, attrs \\ %{}) do
    Practice.changeset(practice, attrs)
  end
end
