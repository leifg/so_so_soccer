defmodule SoSoSoccer.EventSourced.Events.MatchEnded do
  @type t :: %__MODULE__{
    id: non_neg_integer,
    home_team_goal: non_neg_integer,
    away_team_goal: non_neg_integer,
    ended_at: NaiveDateTime.t()
  }

  defstruct [:id, :home_team_goal, :away_team_goal, :ended_at]
end
