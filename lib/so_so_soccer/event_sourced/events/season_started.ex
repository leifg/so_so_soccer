defmodule SoSoSoccer.EventSourced.Events.SeasonStarted do
  @type t :: %__MODULE__{
    id: non_neg_integer,
    started_at: NaiveDateTime.t()
  }

  defstruct [:id, :name, :country_id, :started_at]
end
