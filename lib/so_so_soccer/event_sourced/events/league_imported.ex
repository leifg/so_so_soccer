defmodule SoSoSoccer.EventSourced.Events.LeagueImported do
  @type t :: %__MODULE__{
          id: String.t(),
          country_id: non_neg_integer,
          name: String.t()
        }

  defstruct [:id, :country_id, :name]
end
