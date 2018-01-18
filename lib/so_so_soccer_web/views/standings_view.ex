defmodule SoSoSoccerWeb.StandingsView do
  use SoSoSoccerWeb, :view

  defstruct [
    :position,
    :team,
    :games,
    :wins,
    :draws,
    :losses,
    :goals_for,
    :goals_against,
    :goal_difference,
    :points
  ]

  def season_string_from_key(year) do
    next_year = (rem(year, 100) + 1) |> to_string() |> String.pad_leading(2, "0")
    "#{year}/#{next_year}"
  end

  def from_view_list(list) do
    map_with_index(list)
  end

  def from_app_list(list, team_lookup) do
    Enum.map(list, fn {k, v} ->
      %{
        team_name: team_lookup[k],
        games: v.games,
        wins: v.wins,
        draws: v.draws,
        losses: v.losses,
        goals_for: v.goals_for,
        goals_against: v.goals_against,
        goal_difference: v.goals_for - v.goals_against,
        points: v.points
      }
    end)
    |> Enum.sort_by(
      fn s ->
        {s.points, s.goal_difference, s.goals_for}
      end,
      &>=/2
    )
    |> map_with_index()
  end

  def from_es_list(list) do
    Enum.map(list, fn s ->
      %{
        team_name: s.team_long_name,
        games: s.games,
        wins: s.wins,
        draws: s.draws,
        losses: s.losses,
        goals_for: s.goals_for,
        goals_against: s.goals_against,
        goal_difference: s.goal_difference,
        points: s.points
      }
    end)
    |> map_with_index()
  end

  defp map_with_index(list) do
    list
    |> Enum.with_index(1)
    |> Enum.map(fn {standing, position} ->
      %__MODULE__{
        position: position,
        team: standing.team_name,
        games: standing.games,
        wins: standing.wins,
        draws: standing.draws,
        losses: standing.losses,
        goals_for: standing.goals_for,
        goals_against: standing.goals_against,
        goal_difference: standing.goal_difference,
        points: standing.points
      }
    end)
  end
end
