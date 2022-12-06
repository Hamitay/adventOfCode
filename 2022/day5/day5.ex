defmodule AdventOfCodeDay5 do

  @test_path  "./inputs/test"
  @puzzle_path "./inputs/puzzle"


  defp read_input do
    args = System.argv()

    arg = if length(args) > 0, do: List.first(args), else: ""

    path = if arg == "test", do: @test_path, else: @puzzle_path
    path
    |> File.read!
  end

  defp is_stack_line(line) do
    String.contains?(line, "[")
  end

  defp stack_line_to_list(line) do
    line |> String.to_charlist |> Enum.chunk_every(4)
  end

  defp transfer_box(0, source, destination, :part_one)  do
    {source, destination}
  end

  defp transfer_box(amount, source, destination, :part_one) do
    {box, new_source} = List.pop_at(source, 0)
    new_destination = [box] ++ destination
    transfer_box(amount-1, new_source, new_destination, :part_one)
  end

  defp transfer_box(amount, source, destination, :part_two) do
    {boxes, new_source} = Enum.split(source, amount)
    new_destination = boxes ++ destination
    {new_source, new_destination}
  end

  defp process_instruction(instruction, stacks, mode \\ :part_one) do
    number_to_move = Enum.at(instruction, 0)
    source = Enum.at(instruction, 1)
    destination = Enum.at(instruction, 2)

    source_stack = Enum.at(stacks, source - 1)
    destination_stack = Enum.at(stacks, destination - 1)

    { new_source, new_destination } = transfer_box(number_to_move, source_stack, destination_stack, mode)


    stacks
    |> Enum.with_index()
    |> Enum.map(fn {stack, index} ->
      cond do
        index == source - 1 -> new_source
        index == destination - 1 -> new_destination
        true -> stack
      end
     end)
  end

  defp get_top_boxes(stacks) do
  stacks
    |> Enum.map(fn stack -> Enum.at(stack, 0) end)
    |> Enum.join()
    |> String.replace(~r/(\[)|(\])|(\s)/, "")
  end

  defp parse(input) do
    box_map = input
    |> Enum.filter(&(is_stack_line(&1)))
    |> Enum.map(&(stack_line_to_list(&1)))

    { number_of_stacks, _}  =
      Enum.at(input, length(box_map))
      |> String.last()
      |> Integer.parse()

    stacks = Enum.to_list(1..number_of_stacks)
    |> Enum.map(fn el ->
        box_map
        |> Enum.map(fn x -> Enum.at(x, el-1) end)
        |> Enum.filter(fn x ->
          x != nil && String.contains?(to_string(x), "[")
        end)
      end)

    instructions =
      Enum.slice(input, (length(box_map)+2)..length(input))
      |> Enum.map(fn s -> String.split(s, ~r/(move )|( from )|( to )/, trim: true) end)
      |> Enum.map(fn l -> Enum.map(l, fn c ->
          {r, _} = Integer.parse(c)
          r
        end)
      end)

    top_boxes = instructions
    |> Enum.reduce(stacks, fn inst, state -> process_instruction(inst, state) end)
    |> get_top_boxes()

    # Part one
    IO.puts top_boxes

    top_boxes_two = instructions
    |> Enum.reduce(stacks, fn inst, state -> process_instruction(inst, state, :part_two) end)
    |> get_top_boxes()

    # Part two
    IO.puts top_boxes_two
  end

  def execute do
    read_input()
    |> String.split("\n")
    |> parse
  end
end

AdventOfCodeDay5.execute()
