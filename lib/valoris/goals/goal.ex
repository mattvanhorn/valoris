defmodule Valoris.Goals.Goal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "goals" do
    field :name, :string
    field :purpose, :string

    belongs_to :user, Valoris.Accounts.User
    has_many :actions, Valoris.Progress.Action

    timestamps()
  end

  @doc false
  def changeset(goal, attrs) do
    goal =
      goal
      |> cast(attrs, [:name, :purpose, :user_id])
      |> validate_required([:name, :purpose])

    if attrs["user"] do
      put_assoc(goal, :user, attrs["user"])
    else
      goal
    end
  end
end
