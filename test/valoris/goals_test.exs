defmodule Valoris.GoalsTest do
  use Valoris.DataCase

  alias Valoris.Goals

  describe "goals" do
    alias Valoris.Goals.Goal

    @valid_attrs %{name: "some name", purpose: "some purpose"}
    @update_attrs %{name: "some updated name", purpose: "some updated purpose"}
    @invalid_attrs %{name: nil, purpose: nil}

    def goal_fixture(attrs \\ %{}) do
      {:ok, goal} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Goals.create_goal()

      goal
      |> Valoris.Repo.preload([:tasks, :practices, :actions])
    end

    test "highest_priority/1 returns the oldest goal" do
      older_goal = %Goal{name: "old goal", inserted_at: ~N[2019-03-31 11:30:20]}
      newer_goal = %Goal{name: "new goal", inserted_at: ~N[2020-02-21 01:20:03]}
      assert Goals.highest_priority([newer_goal, older_goal]) == older_goal
    end

    test "list_goals/0 returns all goals" do
      goal = goal_fixture()
      assert Goals.list_goals() == [goal]
    end

    test "get_goal!/1 returns the goal with given id" do
      goal = goal_fixture()
      assert Goals.get_goal!(goal.id) == goal
    end

    test "create_goal/1 with valid data creates a goal" do
      assert {:ok, %Goal{} = goal} = Goals.create_goal(@valid_attrs)
      assert goal.name == "some name"
      assert goal.purpose == "some purpose"
    end

    test "create_goal/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Goals.create_goal(@invalid_attrs)
    end

    test "update_goal/2 with valid data updates the goal" do
      goal = goal_fixture()
      assert {:ok, %Goal{} = goal} = Goals.update_goal(goal, @update_attrs)
      assert goal.name == "some updated name"
      assert goal.purpose == "some updated purpose"
    end

    test "update_goal/2 with invalid data returns error changeset" do
      goal = goal_fixture()
      assert {:error, %Ecto.Changeset{}} = Goals.update_goal(goal, @invalid_attrs)
      assert goal == Goals.get_goal!(goal.id)
    end

    test "delete_goal/1 deletes the goal" do
      goal = goal_fixture()
      assert {:ok, %Goal{}} = Goals.delete_goal(goal)
      assert_raise Ecto.NoResultsError, fn -> Goals.get_goal!(goal.id) end
    end

    test "change_goal/1 returns a goal changeset" do
      goal = goal_fixture()
      assert %Ecto.Changeset{} = Goals.change_goal(goal)
    end
  end

  describe "tasks" do
    alias Valoris.Goals.Task

    @valid_attrs %{index: 42, name: "some name"}
    @update_attrs %{index: 43, name: "some updated name"}
    @invalid_attrs %{index: nil, name: nil}

    def task_fixture(attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Goals.create_task()

      task
      |> Valoris.Repo.preload(:goal)
    end

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Goals.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Goals.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok, %Task{} = task} = Goals.create_task(@valid_attrs)
      assert task.index == 42
      assert task.name == "some name"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Goals.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, %Task{} = task} = Goals.update_task(task, @update_attrs)
      assert task.index == 43
      assert task.name == "some updated name"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Goals.update_task(task, @invalid_attrs)
      assert task == Goals.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Goals.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Goals.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Goals.change_task(task)
    end
  end
end
