defmodule Dallas.Helpers.TableFormatter do

  @doc ~s/
  returns a string of text formated table of the data

  ## Examples

    iex> Dallas.Helpers.TableFormatter.format_lines([["a", "aaa"], ["bbb", "b"], [9, 3]])
    """
    a    aaa
    bbb  b
      9    3
    """

  /
  def format_lines(list) do
    columns_lengths =
      list
      |> Enum.zip()
      |> Enum.map(fn column_tuple ->
        column_tuple
        |> Tuple.to_list
        |> Enum.map(fn value -> value |> to_string |> String.length() end)
        |> Enum.max()
      end)

    for line <- list do
      format_line(line, columns_lengths)
    end
    |> Enum.join("")
  end

  @doc ~s/
  returns a string of text formated table of the data

  ## Examples

    iex> Dallas.Helpers.TableFormatter.format_list(["a", "aaa", "bbb", "b", 9, 3, 15], 2)
    """
    a    aaa
    bbb  b
      9    3
      15
    """

  /
  def format_list(plain_list, columns \\ 8) do
    plain_list
    |> Enum.chunk_every(columns, columns, List.duplicate("", columns))
    |> format_lines()
  end

  defp format_line(line, lengths) do
    line
    |> Enum.zip(lengths)
    |> Enum.map(&format_value/1)
    |> Enum.join("  ")
    |> String.trim_trailing()
    |> Kernel.<>("\n")
  end

  defp format_value({value, length}) when is_number(value) do
    value
    |> to_string
    |> String.pad_leading(length)
  end
  defp format_value({value, length}) do
    value
    |> String.pad_trailing(length)
  end
end
