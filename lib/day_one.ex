defmodule Frequencies do
  @moduledoc false

  @path "input/day_one.txt"

  def get_num_list do
    @path
    |> File.read!()
    |> String.split("\r\n")
    |> Enum.map(&String.to_integer/1)
  end
end

defmodule DayOne do
  @moduledoc false

  @num_list Frequencies.get_num_list()

  def get_resulting_freq, do: Enum.reduce(@num_list, 0, fn x, acc -> x + acc end)

  def get_recurring_freq, do: do_get_recurring_freq(@num_list, [0])

  defp do_get_recurring_freq([], result_freqs), do: do_get_recurring_freq(@num_list, result_freqs)

  defp do_get_recurring_freq([h | t], result_freqs) do
    new_result = h + hd(result_freqs)

    result_freqs
    |> Enum.member?(new_result)
    |> case do
      true -> new_result
      false -> do_get_recurring_freq(t, [new_result | result_freqs])
    end
  end
end

IO.puts(
  "The resulting frequency after all of the changes in frequency, is #{
    DayOne.get_resulting_freq()
  }."
)

IO.puts(
  "The recurring frequency that your device reaches twice is #{DayOne.get_recurring_freq()}."
)
