defmodule Valoris.Progress.Action do
  use Ecto.Schema
  import Ecto.Changeset
  alias Valoris.Goals.Goal

  schema "actions" do
    field :description, :string
    field :title, :string
    belongs_to :goal, Goal

    timestamps()
  end

  @doc false
  def changeset(action, attrs) do
    action
    |> cast(attrs, [:title, :description, :goal_id])
    |> validate_goal(attrs)
    |> validate_required([:title, :description])
  end

  # Inserting a action referencing an existing goal:
  # create_action(%{..., goal_id: 1 })
  defp validate_goal(action, %{"goal_id" => _goal_id}) do
    assoc_constraint(action, :goal)
  end

  # Inserting a action with a goal all at once:
  # create_action(%{..., goal: %{name: "Blah..." } })
  defp validate_goal(action, %{"goal" => _g} = attrs) do
    action
    |> cast_assoc(:goal, required: true)
  end

  defp validate_goal(action, _attrs) do
    action
  end
end
