defmodule AdventOfCodeDay1 do

  @test_path  "./inputs/test"
  @puzzle_path "./inputs/puzzle"

  def read_input do
    args = System.argv()

    arg = if length(args) > 0, do: List.first(args), else: ""

    path = if arg == "test", do: @test_path, else: @puzzle_path
    IO.puts path
    path
    |> File.read!
  end

  def sum_load(elf_load) do
    elf_load
    |> Enum.map(&(Integer.parse(&1)))
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  def execute do
    calories = read_input()
    |> String.split("\n")
    |> Enum.chunk_by(&(&1 != ""))
    |> Enum.filter(fn el -> List.first(el) != "" end)
    |> Enum.map(&(sum_load(&1)))
    |> Enum.sort()
    |> Enum.reverse()

    IO.puts List.first(calories)

    top_three_total = calories
    |> Enum.slice(0, 3)
    |> Enum.sum()

    IO.puts top_three_total
  end
end

AdventOfCodeDay1.execute()
