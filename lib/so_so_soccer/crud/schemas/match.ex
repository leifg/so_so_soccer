defmodule SoSoSoccer.Crud.Schema.Match do
  use Ecto.Schema
  import Ecto.Query, only: [from: 2]
  alias SoSoSoccer.Crud.Repo
  alias SoSoSoccer.Crud.Schema.Team

  @type t :: %__MODULE__{
          id: non_neg_integer,
          country_id: non_neg_integer,
          league_id: non_neg_integer,
          season: non_neg_integer,
          stage: non_neg_integer,
          api_id: non_neg_integer,
          home_team_api_id: non_neg_integer,
          away_team_api_id: non_neg_integer,
          home_team_goal: non_neg_integer,
          away_team_goal: non_neg_integer,
          played_at: NaiveDateTime.t()
        }

  @primary_key {:id, :integer, autogenerate: false}

  schema "matches" do
    field(:country_id, :integer)
    field(:league_id, :integer)
    field(:season, :integer)
    field(:stage, :integer)
    field(:api_id, :integer)
    field(:home_team_api_id, :integer)
    field(:away_team_api_id, :integer)
    field(:home_team_goal, :integer)
    field(:away_team_goal, :integer)
    field(:played_at, :naive_datetime)
  end

  def seasons do
    query = from(m in __MODULE__, distinct: m.season, order_by: [m.season], select: m.season)
    Repo.all(query)
  end

  def standings(season, league_id) do
    team_lookup =
      Repo.all(Team)
      |> Enum.reduce(%{}, fn team, acc ->
        Map.put(acc, team.api_id, team.long_name)
      end)

    query =
      from(
        m in __MODULE__,
        where: m.season == ^season and m.league_id == ^league_id
      )

    query |> Repo.all()
    |> Enum.reduce(%{}, fn row, acc ->
      acc
      |> Map.merge(
        %{
          row.home_team_api_id => %{
            games: 1,
            wins: wins(row.home_team_goal, row.away_team_goal),
            draws: draws(row.home_team_goal, row.away_team_goal),
            losses: losses(row.home_team_goal, row.away_team_goal),
            goals_for: row.home_team_goal,
            goals_against: row.away_team_goal,
            points: points(row.home_team_goal, row.away_team_goal)
          }
        },
        &add_up/3
      )
      |> Map.merge(
        %{
          row.away_team_api_id => %{
            games: 1,
            wins: wins(row.away_team_goal, row.home_team_goal),
            draws: draws(row.away_team_goal, row.home_team_goal),
            losses: losses(row.away_team_goal, row.home_team_goal),
            goals_for: row.away_team_goal,
            goals_against: row.home_team_goal,
            points: points(row.away_team_goal, row.home_team_goal)
          }
        },
        &add_up/3
      )
    end)
  end

  defp points(home_goals, away_goals) do
    cond do
      home_goals > away_goals -> 3
      home_goals < away_goals -> 0
      true -> 1
    end
  end

  defp wins(home_goals, away_goals) do
    if win_indicator(home_goals, away_goals) == 1, do: 1, else: 0
  end

  defp draws(home_goals, away_goals) do
    if win_indicator(home_goals, away_goals) == 0, do: 1, else: 0
  end

  defp losses(home_goals, away_goals) do
    if win_indicator(home_goals, away_goals) == -1, do: 1, else: 0
  end

  defp win_indicator(home_goals, away_goals) do
    cond do
      home_goals > away_goals -> 1
      home_goals < away_goals -> -1
      true -> 0
    end
  end

  def add_up(_k, nil, v2), do: v2
  def add_up(_k, v1, v2) when is_integer(v1), do: v1 + v2
  def add_up(_k, v1, v2) when is_map(v1), do: Map.merge(v1, v2, &add_up/3)
end
