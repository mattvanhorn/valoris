defmodule Valoris.Repo.Migrations.LinkGoalsToUser do
  use Ecto.Migration

  def change do
    alter table(:goals) do
      add :user_id, :integer, references: :users
    end

    create index(:goals, [:user_id])
  end
end
