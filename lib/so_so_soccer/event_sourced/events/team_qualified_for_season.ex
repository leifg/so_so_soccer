defmodule SoSoSoccer.EventSourced.Events.TeamQualifiedForSeason do
  @type t :: %__MODULE__{
          id: String.t(),
          team_api_id: non_neg_integer,
          team_long_name: String.t(),
          team_short_name: String.t(),
          season_id: String.t(),
          league_id: String.t(),
          league_name: String.t()
        }

  defstruct [
    :id,
    :team_api_id,
    :team_long_name,
    :team_short_name,
    :season_id,
    :league_id,
    :league_name
  ]
end
