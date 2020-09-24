defmodule Valoris.Repo.Migrations.CreateActions do
  use Ecto.Migration

  def change do
    create table(:actions) do
      add :title, :string
      add :description, :string
      add :goal_id, references(:goals, on_delete: :delete_all)

      timestamps()
    end

    create index(:actions, [:goal_id])
  end
end
