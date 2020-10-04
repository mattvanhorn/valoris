defmodule Valoris.Repo.Migrations.CreatePractices do
  use Ecto.Migration

  def change do
    create table(:practices) do
      add :name, :string
      add :reason, :string
      add :goal_id, references(:goals, on_delete: :delete_all)

      timestamps()
    end

    create index(:practices, [:goal_id])
  end
end
