defmodule SoSoSoccer.EventSourced.Events.MatchStarted do
  @type t :: %__MODULE__{
    id: non_neg_integer,
    api_id: non_neg_integer,
    country_id: non_neg_integer,
    league_id: non_neg_integer,
    season_id: non_neg_integer,
    stage: non_neg_integer,
    started_at: NaiveDateTime.t(),
    home_team_api_id: non_neg_integer,
    away_team_api_id: non_neg_integer,
  }

  defstruct [
    :id,
    :api_id,
    :country_id,
    :league_id,
    :season_id,
    :stage,
    :started_at,
    :home_team_api_id,
    :away_team_api_id
  ]
end
