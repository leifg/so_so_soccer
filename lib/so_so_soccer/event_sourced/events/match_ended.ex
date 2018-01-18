defmodule SoSoSoccer.EventSourced.Events.MatchEnded do
  @type t :: %__MODULE__{
          id: String.t(),
          home_team_api_id: non_neg_integer,
          away_team_api_id: non_neg_integer,
          home_team_goal: non_neg_integer,
          away_team_goal: non_neg_integer,
          league_id: non_neg_integer,
          season_id: non_neg_integer,
          ended_at: NaiveDateTime.t()
        }

  defstruct [
    :id,
    :home_team_api_id,
    :away_team_api_id,
    :home_team_goal,
    :away_team_goal,
    :league_id,
    :season_id,
    :ended_at
  ]
end
