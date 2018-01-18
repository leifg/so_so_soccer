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
      standings: StandingsView.crud_app(String.to_integer(season), String.to_integer(league_id))
    )
  end
end
