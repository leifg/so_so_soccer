defmodule SoSoSoccer.EventSourced.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams, primary_key: false) do
      add :id, :text, primary_key: true
      add :api_id, :integer
      add :fifa_api_id, :integer
      add :long_name, :text
      add :short_name, :text
    end

    create unique_index(:teams, [:id])
    create unique_index(:teams, [:api_id])
  end
end
