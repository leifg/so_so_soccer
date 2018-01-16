defmodule SoSoSoccer.Crud.Repo.Migrations.CreateStandingsView do
  use Ecto.Migration

  def up do
    execute("""
      create view standings as
      select t.season,
            t.team_id,
            max(te.long_name) as team_name,
            max(t.league_id) as league_id,
            sum(t.games) as games,
            sum(t.wins) as wins,
            sum(t.draws) as draws,
            sum(t.losses) as losses,
            sum(t.goals_for) as goals_for,
            sum(t.goals_against) as goals_against,
            (sum(t.goals_for) - sum(t.goals_against)) as goal_difference,
            sum(t.points) as points
      from
        (select home_team_api_id as team_id,
                m.season,
                max(m.league_id) as league_id,
                count(m.home_team_api_id) as games,
                sum(m.home_team_wins) as wins,
                sum(m.home_team_draws) as draws,
                sum(m.home_team_losses) as losses,
                sum(m.home_team_goal) as goals_for,
                sum(m.away_team_goal) as goals_against,
                sum(m.home_team_points) as points
        from
          (select *,
                  case
                      when home_team_goal > away_team_goal then 3
                      when home_team_goal = away_team_goal then 1
                      else 0
                  end as home_team_points,
                  case
                      when home_team_goal > away_team_goal then 1
                      else 0
                  end as home_team_wins,
                  case
                      when home_team_goal = away_team_goal then 1
                      else 0
                  end as home_team_draws,
                  case
                      when home_team_goal < away_team_goal then 1
                      else 0
                  end as home_team_losses
            from matches) m
        join leagues l on m.league_id = l.id
        group by season,
                  home_team_api_id
        union all select away_team_api_id as team_id,
                          m.season,
                          max(m.league_id) as league_id,
                          count(m.away_team_api_id) as games,
                          sum(m.away_team_wins) as wins,
                          sum(m.away_team_draws) as draws,
                          sum(m.away_team_losses) as losses,
                          sum(m.away_team_goal) as goals_for,
                          sum(m.home_team_goal) as goals_against,
                          sum(m.away_team_points) as points
        from
          (select *,
                  case
                      when away_team_goal > home_team_goal then 3
                      when home_team_goal = away_team_goal then 1
                      else 0
                  end as away_team_points,
                  case
                      when away_team_goal > home_team_goal then 1
                      else 0
                  end as away_team_wins,
                  case
                      when away_team_goal = home_team_goal then 1
                      else 0
                  end as away_team_draws,
                  case
                      when away_team_goal < home_team_goal then 1
                      else 0
                  end as away_team_losses
            from matches) m
        join leagues l on m.league_id = l.id
        group by season,
                  away_team_api_id) t
      join leagues l on t.league_id = l.id
      join teams te on te.api_id = t.team_id
      group by (t.team_id,
                t.season)
      order by points desc,
              goal_difference desc,
              goals_for desc;
    """)
  end

  def down do
    execute("drop view standings;")
  end
end
