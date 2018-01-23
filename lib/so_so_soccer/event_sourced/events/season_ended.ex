defmodule SoSoSoccer.EventSourced.Events.SeasonEnded do
  @type t :: %__MODULE__{
          id: String.t(),
          season_id: String.t(),
          league_id: String.t(),
          ended_at: NaiveDateTime.t()
        }

  defstruct [:id, :season_id, :league_id, :ended_at]
end
