defmodule SoSoSoccer.EventSourced.Schemas.Team do
  use Ecto.Schema

  @type t :: %__MODULE__{
          name: String.t(),
          api_id: non_neg_integer,
          fifa_api_id: String.t(),
          long_name: String.t(),
          short_name: String.t()
        }

  @primary_key {:id, :string, autogenerate: false}

  schema "teams" do
    field(:name, :string)
    field(:api_id, :integer)
    field(:fifa_api_id, :integer)
    field(:long_name, :string)
    field(:short_name, :string)
  end
end
