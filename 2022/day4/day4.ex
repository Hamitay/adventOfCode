defmodule Schedule do
  defstruct starting: 0, ending: 0, length: 0, map: []

  def new(starting, ending) do
    map = Enum.to_list(starting..ending//1)

    %Schedule{
      starting: starting,
      ending: ending,
      length: length(map),
      map: map,
    }
  end
end

defimpl String.Chars, for: Schedule  do

  def to_string(schedule) do
    "Schedule: start: #{schedule.start} \n end: #{schedule.end} \n length: #{schedule.length} \n map: #{schedule.map}"
  end
end

defmodule AdventOfCodeDay4 do

  @test_path  "./inputs/test"
  @puzzle_path "./inputs/puzzle"


  defp read_input do
    args = System.argv()

    arg = if length(args) > 0, do: List.first(args), else: ""

    path = if arg == "test", do: @test_path, else: @puzzle_path
    path
    |> File.read!
  end

  defp parse_schedule(schedule) do
    parsed_schedule = schedule
    |> String.split("-")
    |> Enum.map(&Integer.parse(&1))
    |> Enum.map(fn tuple_result -> elem(tuple_result, 0) end)

    starting = Enum.at(parsed_schedule, 0)
    ending = Enum.at(parsed_schedule, 1)

    Schedule.new(starting, ending)
  end

  defp is_contained?(schedule_a, schedule_b) do
    schedule_a.starting <= schedule_b.starting && schedule_a.ending >= schedule_b.ending
  end

  defp has_containment?(schedule_a, schedule_b) do
    if (schedule_a.length > schedule_b.length) do
      is_contained?(schedule_a, schedule_b)
     else
      is_contained?(schedule_b, schedule_a)
     end
  end

  defp get_containment(schedules) do
    has_containment?(Enum.at(schedules, 0), Enum.at(schedules, 1))
  end

  defp has_overlap(schedules) do
    first_schedule = Enum.at(schedules, 0)
    second_schedule = Enum.at(schedules, 1)

    first_schedule_frequency_map = Enum.frequencies(first_schedule.map)

    second_schedule.map
    |> Enum.any?(fn item -> Map.has_key?(first_schedule_frequency_map, item) end)
  end

  defp parse_assignment(assignment_string) do
    assignment_string
    |> String.split(",")
    |> Enum.map(&(parse_schedule(&1)))
  end

  def execute do
    schedules = read_input()
    |> String.split("\n")
    |> Enum.map(&(parse_assignment(&1)))

    fully_contained_number = schedules
    |> Enum.map(&(get_containment(&1)))
    |> Enum.filter(&(&1))
    |> length()

    overlaps_number = schedules
    |> Enum.map(&(has_overlap(&1)))
    |> Enum.filter(&(&1))
    |> length()

    # Part one
    IO.puts fully_contained_number

    # Part two
    IO.puts overlaps_number
  end
end

AdventOfCodeDay4.execute()
