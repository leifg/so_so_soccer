# SoSoSoccer

This is an example project on how to build a CQRS/ES system using [commanded](https://github.com/commanded). It is a simplified version of Event Sourcing as it does not include aggregates and commands.

It also demonstrates the difference between a CRUD system and an ES system when it comes to data modelling.

This project was subject to an [Event Sourcing Talk](https://speakerdeck.com/leifg/event-sourcing-the-story-telling-of-processes) held in January 2018 in Chiang Mai, Thailand.

## Task

The task is simple. Given a list of soccer matches, calculate the end season standings teable for every season and league. As an input, a sqlite database from kaggle is used (account needed): [https://www.kaggle.com/mkhvalchik/soccer/data](https://www.kaggle.com/mkhvalchik/soccer/data).

There are 3 possible solutions implemented in this project

### The CRUD way calculating the table in application logic

[Function call](lib/so_so_soccer_web/views/standings_view.ex#L22)

Reads the matches and teams data model and calculates the standings in pure Elixir code

### The CRUD way using an SQL view

[Function call](lib/so_so_soccer_web/views/standings_view.ex#L31)

Using an elaborate [SQL view](priv/crud_repo/migrations/20180116103553_create_standings_view.exs) to create the standings table from the data model

### The event sourced way

[Function call](lib/so_so_soccer_web/views/standings_view.ex#L35)

From a stream of events, build a [projection](lib/so_so_soccer/event_sourced/projectors/standings.ex)

## Setting it up

Download [sqlite from kaggle](https://www.kaggle.com/mkhvalchik/soccer/data) (Ideally place the file in `tmp/database.sqlite`)

Start Postgres database via [Docker Compose](https://docs.docker.com/compose/):

```shell
docker-compose up
```

Install dependencies

```shell
mix deps.get
```

Create schema:

```shell
bin/setup.sh
```

Import CRUD data model:

```shell
mix seed_crud_from_sqlite ./tmp/database.sqlite
```

Import Event Source Stream

```shell
mix seed_eventstore_from_sqlite ./tmp/database.sqlite
```

Start server:

```shell
mix phx.server
```


Note: for event sourced view, wait until projection is updated

Go to `localhost:4000` to select the season and leage

## Change way of calculating standings

Play around with the different representations by changing the function all in the [standings controller](lib/so_so_soccer_web/controllers/standings_controller.ex#L15):

```elixir
    # CRUD application logic
    render(
      conn,
      "show.html",
      standings: StandingsView.crud_app(String.to_integer(season), String.to_integer(league_id))
    )

    # CRUD view logic
    render(
      conn,
      "show.html",
      standings: StandingsView.crud_view(String.to_integer(season), String.to_integer(league_id))
    )

    # Event Sourced
    render(
      conn,
      "show.html",
      standings: StandingsView.event_sourced(String.to_integer(season), String.to_integer(league_id))
    )
```

## Benchmark

If you're interested in the performance of the individual implementations, run the benchmark:

```shell
mix run lib/benchmark.exs
```
