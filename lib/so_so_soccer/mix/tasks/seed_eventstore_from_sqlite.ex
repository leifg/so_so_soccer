defmodule Mix.Tasks.SeedEventstoreFromSqlite do
  use Mix.Task
  alias Commanded.EventStore
  alias Commanded.EventStore.EventData

  alias SoSoSoccer.EventSourced.Events.{
    CountryImported,
    LeagueImported,
    MatchEnded,
    MatchStarted,
    SeasonEnded,
    SeasonStarted,
    TeamFounded,
    TeamQualifiedForSeason
  }

  @country_query "select id, name from country"
  @league_query "select id, name from league"
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
      order by season, date;
  """

  @qualifications_query """
  select
  m.season,
  l.id as league_id,
  max(l.name) as league_name,
  t.id as team_id,
  max(t.team_api_id) as team_api_id,
  max(t.team_long_name) as team_long_name,
  max(t.team_short_name) as team_short_name
  from Match m
    join League l on m.league_id = l.id
    join Team t on t.team_api_id = m.home_team_api_id
    where m.season = $1
  group by m.season, l.id, t.id;
  """

  @season_start_query """
    select
      m.season,
      m.league_id,
      min(m.date) as date
      from Match m
        where m.season = $1
        group by season, league_id
        order by season, date;
  """

  @season_end_query """
    select
      m.season,
      m.league_id,
      max(m.date) as date
      from Match m
        where m.season = $1
        group by season, league_id
        order by season, date;
  """

  @start_apps [
    :postgrex,
    :eventstore
  ]

  @shortdoc "Import data from kaggle soccer db"
  def run([filename]) do
    Mix.shell().info("Importing #{filename}")
    prepare()

    Sqlitex.with_db(filename, fn db ->
      Mix.shell().info("Importing Countries")
      {:ok, countries} = Sqlitex.query(db, @country_query)
      insert_countries(countries)

      Mix.shell().info("Importing Leagues")
      {:ok, leagues} = Sqlitex.query(db, @league_query)
      insert_leagues(leagues)

      Mix.shell().info("Importing Teams")
      {:ok, teams} = Sqlitex.query(db, @team_query)
      insert_teams(teams)

      Mix.shell().info("Importing Matches")
      {:ok, matches} = Sqlitex.query(db, @match_query)
      insert_seasons_and_matches(db, matches)
    end)
  end

  defp insert_countries(countries) do
    Enum.each(countries, fn country ->
      stream_id = "country:#{country[:id]}"

      event = %CountryImported{
        id: stream_id,
        name: country[:name]
      }

      {:ok, _version} = EventStore.append_to_stream(stream_id, 0, [wrap(event)])
    end)
  end

  defp insert_leagues(leagues) do
    Enum.each(leagues, fn league ->
      stream_id = "league:#{league[:id]}"

      event = %LeagueImported{
        id: stream_id,
        country_id: league[:country_id],
        name: league[:name]
      }

      {:ok, _version} = EventStore.append_to_stream(stream_id, 0, [wrap(event)])
    end)
  end

  defp insert_teams(teams) do
    Enum.each(teams, fn team ->
      stream_id = "team:#{team[:id]}"

      event = %TeamFounded{
        id: stream_id,
        api_id: team[:api_id],
        fifa_api_id: team[:fifa_api_id],
        long_name: team[:long_name],
        short_name: team[:short_name]
      }

      {:ok, _version} = EventStore.append_to_stream(stream_id, 0, [wrap(event)])
    end)
  end

  defp latest_stream_version(id) do
    Commanded.EventStore.stream_forward(id, 0)
    |> Enum.to_list()
    |> List.last()
    |> Map.get(:stream_version)
  end

  defp qualify_teams(db, season) do
    {:ok, qualifications} = Sqlitex.query(db, @qualifications_query, bind: [season])

    Enum.each(qualifications, fn qualification ->
      stream_id = "team:#{qualification[:team_id]}"

      event = %TeamQualifiedForSeason{
        id: stream_id,
        season_id: season_id(qualification[:season]),
        team_api_id: qualification[:team_api_id],
        team_long_name: qualification[:team_long_name],
        team_short_name: qualification[:team_short_name],
        league_id: "league:#{qualification[:league_id]}",
        league_name: qualification[:league_name]
      }

      {:ok, _version} =
        EventStore.append_to_stream(stream_id, latest_stream_version(stream_id), [wrap(event)])
    end)
  end

  defp insert_season_and_match(db, current_match, last_match) do
    if current_match[:season] != last_match[:season] do
      IO.inspect(last_match[:season], label: "Ending")
      IO.inspect(current_match[:season], label: "Starting")
      IO.puts("=====")
      end_previous_season(db, last_match[:season])
      qualify_teams(db, current_match[:season])
      start_new_season(db, current_match[:season])
    end

    stream_id = "match:#{current_match[:id]}"

    events = [
      %MatchStarted{
        id: stream_id,
        api_id: current_match[:api_id],
        country_id: "country:#{current_match[:country_id]}",
        season_id: season_id(current_match[:season]),
        league_id: "league:#{current_match[:league_id]}",
        stage: current_match[:stage],
        started_at: current_match[:played_at],
        home_team_api_id: current_match[:home_team_api_id],
        away_team_api_id: current_match[:away_team_api_id]
      },
      %MatchEnded{
        id: stream_id,
        home_team_api_id: current_match[:home_team_api_id],
        away_team_api_id: current_match[:away_team_api_id],
        home_team_goal: current_match[:home_team_goal],
        away_team_goal: current_match[:away_team_goal],
        league_id: "league:#{current_match[:league_id]}",
        season_id: season_id(current_match[:season]),
        ended_at: current_match[:played_at]
      }
    ]

    {:ok, _version} = EventStore.append_to_stream(stream_id, 0, Enum.map(events, &wrap/1))

    current_match
  end

  defp insert_seasons_and_matches(db, matches) do
    last_match =
      Enum.reduce(matches, [played_at: nil], fn match, last_match ->
        insert_season_and_match(db, match, last_match)
      end)

    end_previous_season(db, last_match[:season])
  end

  defp start_new_season(db, season) do
    {:ok, seasons} = Sqlitex.query(db, @season_end_query, bind: [season])

    Enum.each(seasons, fn(season_row) ->
      season_id = season_id(season)
      league_id = "league:#{season_row[:league_id]}"
      stream_id = "#{season_id}_#{league_id}"

      event = %SeasonStarted{
        id: stream_id,
        season_id: season_id,
        league_id: league_id,
        started_at: season_row[:date]
      }

      {:ok, _version} = EventStore.append_to_stream(stream_id, 0, [wrap(event)])
    end)
  end

  defp end_previous_season(_db, nil), do: :ok
  defp end_previous_season(db, season) do
    {:ok, seasons} = Sqlitex.query(db, @season_end_query, bind: [season])

    Enum.each(seasons, fn(season_row) ->
      season_id = season_id(season)
      league_id = "league:#{season_row[:league_id]}"
      stream_id = "#{season_id}_#{league_id}"

      event = %SeasonEnded{
        id: stream_id,
        season_id: season_id,
        league_id: league_id,
        ended_at: season_row[:date]
      }

      {:ok, _version} = EventStore.append_to_stream(stream_id, 1, [wrap(event)])
    end)
  end

  defp season_id(season) do
    id = season |> String.split("/") |> List.first() |> String.to_integer()
    "season:#{id}"
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
  end

  defp wrap(event) do
    %EventData{
      event_type: Atom.to_string(event.__struct__),
      data: event,
      metadata: %{}
    }
  end
end
