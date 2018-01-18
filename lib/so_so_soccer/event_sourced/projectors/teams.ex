defmodule SoSoSoccer.EventSourced.Projectors.Teams do
  import Ecto.Query, only: [from: 2]
  use Commanded.Projections.Ecto, name: "EventSourced.Projectors.Teams"

  alias SoSoSoccer.EventSourced.Events.TeamFounded
  alias SoSoSoccer.EventSourced.Schemas.Team

  project %TeamFounded{} = founded do
    Ecto.Multi.insert(multi, :teams, %Team{
      id: founded.id,
      api_id: founded.api_id,
      fifa_api_id: founded.fifa_api_id,
      long_name: founded.long_name,
      short_name: founded.short_name
    })
  end
end
