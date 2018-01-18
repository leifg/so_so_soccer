defmodule SoSoSoccerWeb.StandingsController do
  alias SoSoSoccer.Crud.Schema.{League, Match, Standing, Team}
  alias SoSoSoccer.EventSourced.Schemas.Standing, as: EsStanding
  alias SoSoSoccerWeb.StandingsView
  use SoSoSoccerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", leagues: League.all(), seasons: Match.seasons())
  end

  def show(conn, %{"season" => season, "league_id" => league_id}) do
    render(
      conn,
      "show.html",
      standings: es_standings(String.to_integer(season), String.to_integer(league_id))
    )
  end

  defp view_standings(season, league_id) do
    Standing.by_season_and_league(season, league_id) |> StandingsView.from_view_list()
  end

  defp app_standings(season, league_id) do
    team_lookup =
      Team.all()
      |> Enum.reduce(%{}, fn t, acc ->
        Map.put(acc, t.api_id, t.long_name)
      end)

    Match.standings(season, league_id) |> StandingsView.from_app_list(team_lookup)
  end

  defp es_standings(season, league_id) do
    EsStanding.by_season_and_league(season, league_id)  |> StandingsView.from_es_list()
  end
end
