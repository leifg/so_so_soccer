defmodule SoSoSoccer.Crud.Schema.League do
  use Ecto.Schema
  alias SoSoSoccer.Crud.Repo

  @type t :: %__MODULE__{
          id: non_neg_integer,
          country_id: non_neg_integer,
          name: String.t()
        }

  @primary_key {:id, :integer, autogenerate: false}

  schema "leagues" do
    field(:country_id, :integer)
    field(:name, :string)
  end

  def all do
    Repo.all(__MODULE__)
  end
end
