defmodule SoSoSoccer.Crud.Schema.Country do
  use Ecto.Schema

  @type t :: %__MODULE__{
          id: non_neg_integer,
          name: String.t()
        }

  @primary_key {:id, :integer, autogenerate: false}

  schema "countries" do
    field(:name, :string)
  end
end
