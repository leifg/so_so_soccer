defmodule SoSoSoccer.EventSourced.Events.SeasonStarted do
  @type t :: %__MODULE__{
          id: String.t(),
          started_at: NaiveDateTime.t()
        }

  defstruct [:id, ,:started_at]
end
