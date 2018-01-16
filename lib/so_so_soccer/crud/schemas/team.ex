defmodule SoSoSoccer.Crud.Schema.Team do
  use Ecto.Schema

  @type t :: %__MODULE__{
          id: non_neg_integer,
          api_id: non_neg_integer,
          fifa_api_id: non_neg_integer,
          long_name: String.t(),
          short_name: String.t()
        }

  @primary_key {:id, :integer, autogenerate: false}

  schema "teams" do
    field(:api_id, :integer)
    field(:fifa_api_id, :integer)
    field(:long_name, :string)
    field(:short_name, :string)
  end
end
