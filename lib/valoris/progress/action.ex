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
    |> validate_required([:title, :description])
    |> associate_goal(attrs)
  end

  # Inserting a action referencing an existing goal:
  # create_action(%{..., goal_id: 1 })
  defp associate_goal(action, %{"goal_id" => _goal_id}) do
    assoc_constraint(action, :goal)
  end

  defp associate_goal(action, _attrs) do
    action
  end
end
