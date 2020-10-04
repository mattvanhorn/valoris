defmodule Valoris.Goals.Practice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "practices" do
    field :name, :string
    field :reason, :string
    belongs_to :goal, Valoris.Goals.Goal

    timestamps()
  end

  @doc false
  def changeset(practice, attrs) do
    practice
    |> cast(attrs, [:name, :reason])
    |> validate_required([:name])

    # |> assoc_constraint(practice, :goal)
  end
end
