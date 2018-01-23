defmodule SoSoSoccer.EventSourced.Events.SeasonStarted do
  @type t :: %__MODULE__{
          id: String.t(),
          season_id: String.t(),
          league_id: String.t(),
          started_at: NaiveDateTime.t()
        }

  defstruct [:id, :season_id, :league_id, :started_at]
end
