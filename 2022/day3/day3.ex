defmodule AdventOfCodeDay3 do

  @test_path  "./inputs/test"
  @puzzle_path "./inputs/puzzle"

  defp read_input do
    args = System.argv()

    arg = if length(args) > 0, do: List.first(args), else: ""

    path = if arg == "test", do: @test_path, else: @puzzle_path
    path
    |> File.read!
  end


  defp split_rucksack(rucksack) do
    compartment_size = String.length(rucksack)/2 |> trunc

    [
      String.slice(rucksack, 0, compartment_size),
      String.slice(rucksack, compartment_size, String.length(rucksack))
    ]
  end


  defp find_common_item(compartments) do
    first_compartment = Enum.at(compartments, 0)
    second_compartment = Enum.at(compartments, 1)

    first_compartment_items = first_compartment
    |> String.to_charlist()
    |> Enum.frequencies()

    second_compartment
    |> String.to_charlist()
    |> Enum.find(fn item -> Map.has_key?(first_compartment_items, item) end)
  end

  defp get_item_priority(item) when item < 97 do
    item - 65 + 27
  end

  defp get_item_priority(item) do
    item - 97 + 1
  end

  defp find_group_badge(group) do
    first_rucksack = Enum.at(group, 0)
    second_rucksack = Enum.at(group, 1)
    third_rucksack = Enum.at(group, 2)

    first_rucksack_items = first_rucksack
    |> String.to_charlist()
    |> Enum.frequencies()

    second_rucksack_items = second_rucksack
    |> String.to_charlist()
    |> Enum.frequencies()

    third_rucksack
    |> String.to_charlist()
    |> Enum.find(fn item ->
        Map.has_key?(first_rucksack_items, item) &&
        Map.has_key?(second_rucksack_items, item)
      end)
  end

  def execute do
    item_priority = read_input()
    |> String.split("\n")
    |> Enum.map(&(split_rucksack(&1)))
    |> Enum.map(&(find_common_item(&1)))
    |> Enum.map(&(get_item_priority(&1)))
    |> Enum.sum()

    # Part one
    IO.puts item_priority

    badge_priority = read_input()
    |> String.split("\n")
    |> Enum.chunk_every(3)
    |> Enum.map(&(find_group_badge(&1)))
    |> Enum.map(&(get_item_priority(&1)))
    |> Enum.sum()


    # Part two
    IO.puts badge_priority
  end
end

AdventOfCodeDay3.execute()
