defmodule SoSoSoccer.EventSourcedRepo.Migrations.CreatedStandings do
  use Ecto.Migration

  def change do
    create table(:standings, primary_key: false) do
      add :season_id, :integer
      add :team_api_id, :integer
      add :team_long_name, :text
      add :league_id, :integer
      add :games, :integer, default: 0
      add :wins, :integer, default: 0
      add :draws, :integer, default: 0
      add :goals_for, :integer, default: 0
      add :goals_against, :integer, default: 0
      add :goal_difference, :integer, default: 0
      add :losses, :integer, default: 0
      add :points, :integer, default: 0
      add :sort_key, :text
    end

    create unique_index(:standings, [:season_id, :team_api_id])
    create index(:standings, [:sort_key])
  end
end
