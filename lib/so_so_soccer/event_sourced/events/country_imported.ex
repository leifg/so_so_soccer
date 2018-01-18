defmodule SoSoSoccer.EventSourced.Events.CountryImported do
  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t()
        }

  defstruct [:id, :name]
end
