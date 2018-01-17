defmodule SoSoSoccer.EventSourced.Events.SeasonEnded do
  @type t :: %__MODULE__{
    id: non_neg_integer,
    ended_at: NaiveDateTime.t()
  }

  defstruct [:id, :ended_at]
end
