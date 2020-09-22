defmodule Valoris.Goals.Goal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "goals" do
    field :name, :string
    field :purpose, :string

    timestamps()
  end

  @doc false
  def changeset(goal, attrs) do
    goal
    |> cast(attrs, [:name, :purpose])
    |> validate_required([:name, :purpose])
  end
end