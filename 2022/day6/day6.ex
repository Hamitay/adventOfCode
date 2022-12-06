defmodule AdventOfCodeDay6 do

  @test_path  "./inputs/test"
  @puzzle_path "./inputs/puzzle"

  @protocol_packet_size 4
  @message_packet_size 14

  defp read_input do
    args = System.argv()

    arg = if length(args) > 0, do: List.first(args), else: ""

    path = if arg == "test", do: @test_path, else: @puzzle_path
    path
    |> File.read!
  end


  defp find_packet_start(signal, lower, upper, packet_size) do
    unique_packet_size = String.slice(signal, lower..upper)
    |> String.to_charlist()
    |> Enum.frequencies()
    |> Enum.count()


    if unique_packet_size == packet_size do
      upper+1
    else
      find_packet_start(signal, lower+1, upper+1, packet_size)
    end
  end

  defp find_packet_start(signal) do
    find_packet_start(signal, 0, 3, @protocol_packet_size)
  end

  defp find_message_start(signal) do
    find_packet_start(signal, 0, 13, @message_packet_size)
  end

  def execute do
    input = read_input()

    # Part one
    input
    |> find_packet_start()
    |> IO.inspect()

    # Part two
    input
    |> find_message_start()
    |> IO.inspect()
  end
end

AdventOfCodeDay6.execute()
