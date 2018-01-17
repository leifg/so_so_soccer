defmodule SoSoSoccerWeb.StandingsController do
  alias SoSoSoccer.Crud.Schema.{League, Match, Standing}
  use SoSoSoccerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", leagues: League.all(), seasons: Match.seasons())
  end

  def show(conn, %{"season" => season, "league_id" => league_id}) do
    standings =
      Standing.by_season_and_league(String.to_integer(season), String.to_integer(league_id))
      |> SoSoSoccerWeb.StandingsView.from_crud_list()

    render(conn, "show.html", standings: standings)
  end
end
