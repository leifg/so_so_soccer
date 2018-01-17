defmodule SoSoSoccer.EventSourced.Events.TeamFounded do
  @type t :: %__MODULE__{
    id: non_neg_integer,
    api_id: non_neg_integer,
    fifa_api_id: non_neg_integer,
    long_name: String.t(),
    short_name: String.t()
  }

  defstruct [:id, :api_id, :fifa_api_id, :long_name, :short_name]
end
