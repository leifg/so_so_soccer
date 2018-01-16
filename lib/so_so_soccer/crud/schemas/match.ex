defmodule SoSoSoccer.Crud.Schema.Match do
  use Ecto.Schema

  @type t :: %__MODULE__{
          id: non_neg_integer,
          country_id: non_neg_integer,
          league_id: non_neg_integer,
          season: String.t(),
          stage: non_neg_integer,
          api_id: non_neg_integer,
          home_team_api_id: non_neg_integer,
          away_team_api_id: non_neg_integer,
          home_team_goal: non_neg_integer,
          away_team_goal: non_neg_integer,
          played_at: NaiveDateTime.t()
        }

  @primary_key {:id, :integer, autogenerate: false}

  schema "matches" do
    field(:country_id, :integer)
    field(:league_id, :integer)
    field(:season, :string)
    field(:stage, :integer)
    field(:api_id, :integer)
    field(:home_team_api_id, :integer)
    field(:away_team_api_id, :integer)
    field(:home_team_goal, :integer)
    field(:away_team_goal, :integer)
    field(:played_at, :naive_datetime)
  end
end
