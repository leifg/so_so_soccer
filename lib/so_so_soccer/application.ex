defmodule SoSoSoccer.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(SoSoSoccer.CrudRepo, []),
      supervisor(SoSoSoccer.EventSourcedRepo, []),
      supervisor(SoSoSoccerWeb.Endpoint, []),
      worker(SoSoSoccer.EventSourced.Projectors.Teams, [], id: :teams_projector),
      worker(SoSoSoccer.EventSourced.Projectors.Standings, [], id: :standings_projector)
    ]

    opts = [strategy: :one_for_one, name: SoSoSoccer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    SoSoSoccerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
