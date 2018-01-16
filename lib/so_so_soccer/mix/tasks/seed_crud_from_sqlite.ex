defmodule Mix.Tasks.SeedCrudFromSqlite do
  use Mix.Task
  alias SoSoSoccer.Crud.Repo
  alias SoSoSoccer.Crud.Schema.{Country, League, Team, Match}

  @batch_size 1000
  @country_query "select id, name from country"
  @league_query "select id, country_id, name from league"
  @team_query """
    select
      id,
      team_api_id as api_id,
      team_fifa_api_id as fifa_api_id,
      team_long_name as long_name,
      team_short_name as short_name
      from team
  """
  @match_query """
    select
      id,
      country_id,
      league_id,
      season,
      stage,
      datetime(date) as played_at,
      match_api_id as api_id,
      home_team_api_id,
      away_team_api_id,
      home_team_goal,
      away_team_goal
      from match
  """

  @start_apps [
    :postgrex,
    :ecto
  ]

  @shortdoc "Import data from kaggle soccer db"
  def run([filename]) do
    Mix.shell().info("Importing #{filename}")
    prepare()
    drop_postgres()

    Sqlitex.with_db(filename, fn db ->
      Mix.shell().info("Importing Countries")
      {:ok, countries} = Sqlitex.query(db, @country_query)
      insert(Country, countries)

      Mix.shell().info("Importing Leagues")
      {:ok, leagues} = Sqlitex.query(db, @league_query)
      insert(League, leagues)

      Mix.shell().info("Importing Teams")
      {:ok, teams} = Sqlitex.query(db, @team_query)
      insert(Team, teams)

      Mix.shell().info("Importing Matches")
      {:ok, matches} = Sqlitex.query(db, @match_query)
      insert(Match, matches)
    end)
  end

  defp insert(Match, items) do
    transformed =
      Enum.map(items, fn i ->
        Keyword.put(i, :played_at, NaiveDateTime.from_iso8601!(i[:played_at]))
      end)

    batch_insert(Match, transformed, @batch_size)
  end

  defp insert(struct, items) do
    batch_insert(struct, items, @batch_size)
  end

  def batch_insert(struct, items, batch_size) do
    Enum.chunk_every(items, batch_size)
    |> Enum.each(fn batch ->
      Repo.insert_all(struct, batch)
    end)
  end

  defp myapp, do: :so_so_soccer

  defp prepare do
    me = myapp()

    IO.puts("Loading #{me}..")
    # Load the code for myapp, but don't start it
    Application.load(me)

    IO.puts("Starting dependencies..")
    # Start apps necessary for executing migrations
    Enum.each(@start_apps, fn app ->
      {:ok, _} = Application.ensure_all_started(app)
    end)

    # Start the Repo(s) for myapp
    IO.puts("Starting repo..")
    Repo.start_link(pool_size: 1)
  end

  defp drop_postgres do
    query = """
    truncate table
      countries,
      leagues,
      teams,
      matches
    restart identity;
    """

    Ecto.Adapters.SQL.query!(Repo, query, [])
  end
end
