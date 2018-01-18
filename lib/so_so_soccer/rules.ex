defmodule SoSoSoccer.Rules do
  def points(home_goals, away_goals) do
    cond do
      home_goals > away_goals -> 3
      home_goals < away_goals -> 0
      true -> 1
    end
  end

  def wins(hg, ag), do: game_info(hg, ag).wins
  def draws(hg, ag), do: game_info(hg, ag).draws
  def losses(hg, ag), do: game_info(hg, ag).losses

  defp game_info(home_goals, away_goals) do
    cond do
      home_goals > away_goals -> %{wins: 1, draws: 0, losses: 0}
      home_goals < away_goals -> %{wins: 0, draws: 0, losses: 1}
      true -> %{wins: 0, draws: 1, losses: 0}
    end
  end
end
