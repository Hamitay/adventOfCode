defmodule AdventOfCodeDay2 do

  @test_path  "./inputs/test"
  @puzzle_path "./inputs/puzzle"

  @opponent_map %{"A" => :rock, "B" => :paper, "C" => :scissors}
  @player_map %{"X" => :rock, "Y" => :paper, "Z" => :scissors}
  @player_point_map %{:rock => 1, :paper => 2, :scissors => 3}

  @result_map %{"X" => :lost, "Y" => :draw, "Z" => :win}

  @score_map %{:win => 6, :draw => 3, :lost => 0}


  defp read_input do
    args = System.argv()

    arg = if length(args) > 0, do: List.first(args), else: ""

    path = if arg == "test", do: @test_path, else: @puzzle_path
    path
    |> File.read!
  end

  defp match_result(opponent_play, player_play) when opponent_play == player_play, do: :draw

  defp match_result(opponent_play, player_play) do
    case {opponent_play, player_play} do
      {:paper, :rock} -> :lost
      {:paper, :scissors} -> :win

      {:rock, :scissors} -> :lost
      {:rock, :paper} -> :win

      {:scissors, :paper} -> :lost
      {:scissors, :rock} -> :win
    end
  end

  defp match_play(opponent_play, :draw), do: opponent_play

  defp match_play(opponent_play, result) do
    case {opponent_play, result} do
      {:paper, :win} -> :scissors
      {:paper, :lost} -> :rock

      {:scissors, :win} -> :rock
      {:scissors, :lost} -> :paper

      {:rock, :win} -> :paper
      {:rock, :lost} -> :scissors
    end
  end

  defp total_score(result, player_play) do
    Map.fetch!(@score_map, result) + Map.fetch!(@player_point_map, player_play)
  end

  defp split_game_string(game_string) do
    game_string |> String.split(" ")
  end

  defp calculate_points_by_play(game) do
    [opponent, player] = split_game_string(game)

    opponent_play = Map.fetch!(@opponent_map, opponent)
    player_play = Map.fetch!(@player_map, player)

    match_result(opponent_play, player_play)
    |> total_score(player_play)
  end

  defp calculate_points_by_result(game) do
    [opponent, player] = split_game_string(game)

    opponent_play = Map.fetch!(@opponent_map, opponent)
    result = Map.fetch!(@result_map, player)

    player_play = match_play(opponent_play, result)

    total_score(result, player_play)
  end

  def execute do
    games = read_input()
    |> String.split("\n")

    total_points_by_play = games
    |> Enum.map(&(calculate_points_by_play(&1)))
    |> Enum.sum()

    # Part one
    IO.puts total_points_by_play

    total_points_by_result = games
    |> Enum.map(&(calculate_points_by_result(&1)))
    |> Enum.sum()

    # Part two
    IO.puts total_points_by_result
  end
end

AdventOfCodeDay2.execute()
