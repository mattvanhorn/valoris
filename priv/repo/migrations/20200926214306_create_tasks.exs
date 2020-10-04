defmodule Valoris.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string
      add :index, :integer
      add :goal_id, references(:goals, on_delete: :delete_all)

      timestamps()
    end

    create index(:tasks, [:goal_id])
  end
end
