defmodule SoSoSoccer.Crud.Repo.Migrations.CreateSchema do
  use Ecto.Migration

  def change do
    create table("countries") do
      add(:name, :string)
    end

    create table("leagues") do
      add(:country_id, :integer)
      add(:name, :string)
    end

    create(index("leagues", [:country_id]))

    create table("teams") do
      add(:api_id, :integer)
      add(:fifa_api_id, :integer)
      add(:long_name, :string)
      add(:short_name, :string)
    end

    create(index("teams", [:api_id]))

    create table("matches") do
      add(:country_id, :integer)
      add(:league_id, :integer)
      add(:season, :integer)
      add(:stage, :integer)
      add(:api_id, :integer)
      add(:home_team_api_id, :integer)
      add(:away_team_api_id, :integer)
      add(:home_team_goal, :integer, default: 0)
      add(:away_team_goal, :integer, default: 0)
      add(:played_at, :utc_datetime)
    end

    create(index("matches", [:home_team_api_id]))
    create(index("matches", [:away_team_api_id]))
    create(index("matches", [:season]))
  end
end
