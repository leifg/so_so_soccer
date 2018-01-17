defmodule SoSoSoccer.Crud.Schema.Standing do
  use Ecto.Schema
  import Ecto.Query, only: [from: 2]
  alias SoSoSoccer.Crud.Repo

  @type t :: %__MODULE__{
          season: non_neg_integer,
          team_id: non_neg_integer,
          team_name: String.t(),
          league_id: non_neg_integer,
          games: non_neg_integer,
          wins: non_neg_integer,
          draws: non_neg_integer,
          losses: non_neg_integer,
          goals_for: non_neg_integer,
          goals_against: non_neg_integer,
          goal_difference: non_neg_integer,
          points: non_neg_integer
        }

  @primary_key false
  schema "standings" do
    field(:season, :integer)
    field(:team_id, :integer)
    field(:team_name, :string)
    field(:league_id, :integer)
    field(:games, :integer)
    field(:wins, :integer)
    field(:draws, :integer)
    field(:losses, :integer)
    field(:goals_for, :integer)
    field(:goals_against, :integer)
    field(:goal_difference, :integer)
    field(:points, :integer)
  end

  def by_season_and_league(season, league_id) do
    from(s in __MODULE__, where: s.season == ^season and s.league_id == ^league_id) |> Repo.all()
  end
end
