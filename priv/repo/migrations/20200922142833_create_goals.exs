defmodule Valoris.Repo.Migrations.CreateGoals do
  use Ecto.Migration

  def change do
    create table(:goals) do
      add :name, :string
      add :purpose, :string

      timestamps()
    end

  end
end
