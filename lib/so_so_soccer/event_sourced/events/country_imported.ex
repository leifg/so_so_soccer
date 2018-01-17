defmodule SoSoSoccer.EventSourced.Events.CountryImported do
  @type t :: %__MODULE__{
    id: non_neg_integer,
    name: String.t(),
  }

  defstruct [:id, :name]
end
