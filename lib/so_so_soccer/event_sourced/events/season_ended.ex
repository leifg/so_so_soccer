defmodule SoSoSoccer.EventSourced.Events.SeasonEnded do
  @type t :: %__MODULE__{
          id: String.t(),
          ended_at: NaiveDateTime.t()
        }

  defstruct [:id, :ended_at]
end
