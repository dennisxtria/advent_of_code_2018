defmodule Checksum do
  @moduledoc false

  @path "input/day_two.txt"

  def get_candidate_list do
    @path
    |> File.read!()
    |> String.split("\r\n")
  end
end

defmodule DayTwo do
  @moduledoc false

  @candidate_list Checksum.get_candidate_list()

  def get_checksum do
    result =
      Enum.reduce(@candidate_list, %{two: 0, three: 0}, fn x, acc ->
        acc =
          case create_candidate_map(x, %{}) do
            [2] ->
              Map.put(acc, :two, Map.get(acc, :two) + 1)

            [2, 3] ->
              acc
              |> Map.put(:two, Map.get(acc, :two) + 1)
              |> Map.put(:three, Map.get(acc, :three) + 1)

            [3] ->
              Map.put(acc, :three, Map.get(acc, :three) + 1)

            [3, 2] ->
              acc
              |> Map.put(:two, Map.get(acc, :two) + 1)
              |> Map.put(:three, Map.get(acc, :three) + 1)

            [] ->
              acc
          end

        acc
      end)

    %{two: two, three: three} = result
    two * three
  end

  def get_most_common_letters do
    [box_id_1, box_id_2] = do_get1(@candidate_list)
    do_get_most_common_letters(box_id_1, box_id_2, "")
  end

  defp create_candidate_map("", map) do
    map
    |> Map.values()
    |> Enum.filter(fn x -> x == 2 || x == 3 end)
    |> Enum.uniq()
  end

  defp create_candidate_map(<<a::binary-size(1), rest::binary>>, map) do
    frequency = Map.get(map, a)

    map =
      case frequency do
        nil -> Map.put(map, a, 1)
        _ -> Map.put(map, a, frequency + 1)
      end

    create_candidate_map(rest, map)
  end

  defp do_get1([h | t]) do
    do_get2(h, t, t)
  end

  defp do_get2(_h, [], acc), do: do_get1(acc)

  defp do_get2(h, [a | b], acc) do
    case compare(h, a, 0) do
      :one -> [h, a]
      :two -> do_get2(h, b, acc)
    end
  end

  defp compare("", "", 1), do: :one
  defp compare(_, _, 2), do: :two

  defp compare(<<x::binary-size(1), rest_x::binary>>, <<y::binary-size(1), rest_y::binary>>, 0) do
    case x == y do
      true -> compare(rest_x, rest_y, 0)
      false -> compare(rest_x, rest_y, 1)
    end
  end

  defp compare(<<x::binary-size(1), rest_x::binary>>, <<y::binary-size(1), rest_y::binary>>, 1) do
    case x == y do
      true -> compare(rest_x, rest_y, 1)
      false -> compare(rest_x, rest_y, 2)
    end
  end

  defp do_get_most_common_letters("", "", acc), do: acc

  defp do_get_most_common_letters(
         <<x::binary-size(1), rest_x::binary>>,
         <<y::binary-size(1), rest_y::binary>>,
         acc
       ) do
    case x == y do
      true -> do_get_most_common_letters(rest_x, rest_y, acc <> x)
      false -> do_get_most_common_letters(rest_x, rest_y, acc)
    end
  end
end

# IO.puts("The checksum for the list of box IDs is #{DayTwo.get_checksum()}.")

# IO.puts(
#   "The most common letters between the two correct box IDs are #{DayTwo.get_most_common_letters()}."
# )
