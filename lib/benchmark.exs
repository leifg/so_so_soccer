season = 2015
league_id = 7809

Benchee.run(%{
  "CRUD app"        => fn -> SoSoSoccerWeb.StandingsView.crud_app(season, league_id) end,
  "CRUD view"       => fn -> SoSoSoccerWeb.StandingsView.crud_view(season, league_id) end,
  "Event Sourced"   => fn -> SoSoSoccerWeb.StandingsView.event_sourced(season, league_id) end,
}, time: 10)
