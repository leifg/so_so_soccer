defmodule SoSoSoccer.EventSourced.Schemas.Standing do
  use Ecto.Schema
  import Ecto.Query, only: [from: 2]
  alias SoSoSoccer.EventSourcedRepo, as: Repo

  @type t :: %__MODULE__{
          season_id: non_neg_integer,
          team_api_id: non_neg_integer,
          team_long_name: String.t(),
          league_id: non_neg_integer,
          games: non_neg_integer,
          wins: non_neg_integer,
          draws: non_neg_integer,
          losses: non_neg_integer,
          goals_for: non_neg_integer,
          goals_against: non_neg_integer,
          goal_difference: non_neg_integer,
          points: non_neg_integer,
          sort_key: String.t()
        }

  @primary_key false

  schema "standings" do
    field(:season_id, :integer, primary_key: true)
    field(:team_api_id, :integer, primary_key: true)
    field(:team_long_name, :string)
    field(:league_id, :integer)
    field(:games, :integer)
    field(:wins, :integer)
    field(:draws, :integer)
    field(:losses, :integer)
    field(:goals_for, :integer)
    field(:goals_against, :integer)
    field(:goal_difference, :integer)
    field(:points, :integer)
    field(:sort_key, :string)
  end

  def by_team_and_season(team_api_id, season_id) do
    Repo.get_by(__MODULE__, %{team_api_id: team_api_id, season_id: season_id})
  end

  def by_season_and_league(season_id, league_id) do
    from(s in __MODULE__, where: s.season_id == ^season_id and s.league_id == ^league_id, order_by: [desc: s.sort_key]) |> Repo.all()
  end
end
