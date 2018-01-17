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
    two_digit_year = year |> String.to_integer() |> rem(100)
    next_year = to_string(two_digit_year + 1) |> String.pad_leading(2, "0")
    "#{year}/#{next_year}"
  end

  def from_crud_list(list) do
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
