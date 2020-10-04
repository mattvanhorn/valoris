defmodule Valoris.Goals.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :index, :integer
    field :name, :string
    belongs_to :goal, Valoris.Goals.Goal

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :index])
    |> validate_required([:name])

    # |> assoc_constraint(task, :goal)
  end
end
