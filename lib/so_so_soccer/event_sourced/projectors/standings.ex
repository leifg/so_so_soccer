defmodule SoSoSoccer.EventSourced.Projectors.Standings do
  import Ecto.Query, only: [from: 2]
  use Commanded.Projections.Ecto, name: "EventSourced.Projectors.Standings"

  alias SoSoSoccer.EventSourced.Events.{MatchEnded, TeamQualifiedForSeason}
  alias SoSoSoccer.EventSourced.Schemas.Standing
  alias SoSoSoccer.Rules

  project %TeamQualifiedForSeason{} = qualified do
    Ecto.Multi.insert(multi, :standings, %Standing{
      season_id: id_from_stream_id(qualified.season_id),
      team_api_id: qualified.team_api_id,
      team_long_name: qualified.team_long_name,
      league_id: id_from_stream_id(qualified.league_id),
      sort_key: sort_key(0, 0, 0)
    })
  end

  project %MatchEnded{} = ended do
    season_id = id_from_stream_id(ended.season_id)

    home_team = Standing.by_team_and_season(ended.home_team_api_id, season_id)
    away_team = Standing.by_team_and_season(ended.away_team_api_id, season_id)

    home_team_changeset = team_changeset(home_team, ended.home_team_goal, ended.away_team_goal)
    away_team_changeset = team_changeset(away_team, ended.away_team_goal, ended.home_team_goal)

    multi |> Ecto.Multi.update(:home_team, home_team_changeset)
    |> Ecto.Multi.update(:away_team, away_team_changeset)
  end

  defp id_from_stream_id(stream_id) do
    stream_id |> String.split(":") |> List.last() |> String.to_integer()
  end

  defp sort_key(points, goals_for, goals_against) do
    "#{pad4(points)}##{pad4(goals_for)}##{pad4(goals_for - goals_against)}"
  end

  defp pad4(i) do
    String.pad_leading(to_string(i), 4, "0")
  end

  defp team_changeset(team, goals_for, goals_against) do
    new_goals_for = team.goals_for + goals_for
    new_goals_against = team.goals_against + goals_against
    new_points = team.points + Rules.points(goals_for, goals_against)

    Ecto.Changeset.change(team, %{
      games: team.games + 1,
      wins: team.wins + Rules.wins(goals_for, goals_against),
      draws: team.draws + Rules.draws(goals_for, goals_against),
      losses: team.losses + Rules.losses(goals_for, goals_against),
      goals_for: new_goals_for,
      goals_against: new_goals_against,
      goal_difference: team.goal_difference + (goals_for - goals_against),
      points: new_points,
      sort_key: sort_key(new_points, new_goals_for, new_goals_against)
    })
  end
end
