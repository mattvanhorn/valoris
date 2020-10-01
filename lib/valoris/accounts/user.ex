defmodule Valoris.Accounts.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    pow_user_fields()
    has_many :goals, Valoris.Goals.Goal
    timestamps()
  end
end
