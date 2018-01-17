defmodule SoSoSoccerWeb.Router do
  use SoSoSoccerWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", SoSoSoccerWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", StandingsController, :index)
    get("/:league_id/:season", StandingsController, :show)
  end
end
