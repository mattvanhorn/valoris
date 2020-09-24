defmodule Valoris.ProgressTest do
  use Valoris.DataCase

  alias Valoris.Progress

  describe "actions" do
    alias Valoris.Progress.Action

    @valid_attrs %{description: "some description", title: "some title"}
    @update_attrs %{description: "some updated description", title: "some updated title"}
    @invalid_attrs %{description: nil, title: nil}

    def action_fixture(attrs \\ %{}) do
      {:ok, action} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Progress.create_action()

      action
    end

    test "list_actions/0 returns all actions" do
      action = action_fixture()
      assert Progress.list_actions() == [action]
    end

    test "get_action!/1 returns the action with given id" do
      action = action_fixture()
      assert Progress.get_action!(action.id) == action
    end

    test "create_action/1 with valid data creates a action" do
      assert {:ok, %Action{} = action} = Progress.create_action(@valid_attrs)
      assert action.description == "some description"
      assert action.title == "some title"
    end

    test "create_action/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Progress.create_action(@invalid_attrs)
    end

    test "update_action/2 with valid data updates the action" do
      action = action_fixture()
      assert {:ok, %Action{} = action} = Progress.update_action(action, @update_attrs)
      assert action.description == "some updated description"
      assert action.title == "some updated title"
    end

    test "update_action/2 with invalid data returns error changeset" do
      action = action_fixture()
      assert {:error, %Ecto.Changeset{}} = Progress.update_action(action, @invalid_attrs)
      assert action == Progress.get_action!(action.id)
    end

    test "delete_action/1 deletes the action" do
      action = action_fixture()
      assert {:ok, %Action{}} = Progress.delete_action(action)
      assert_raise Ecto.NoResultsError, fn -> Progress.get_action!(action.id) end
    end

    test "change_action/1 returns a action changeset" do
      action = action_fixture()
      assert %Ecto.Changeset{} = Progress.change_action(action)
    end
  end
end
