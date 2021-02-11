defmodule Dallas.Helpers.TableFormatter do

  @doc """
  returns a string of text formated table of the data

  ## Examples

      iex> Dallas.Helpers.TableFormatter.format_list([["a", "aaa"], ["bbb", "b"]])
      :world

  """
  def format_list(list) do
    columns_lengths =
      list
      |> Enum.zip()
      |> Enum.map(fn column_tuple ->
        column_tuple
        |> Tuple.to_list
        |> Enum.map(&String.length/1)
        |> Enum.max()
      end)

    for line <- list do
      format_line(line, columns_lengths)
    end
    |> Enum.join("\n")
  end

  defp format_line(line, lengths) do
    line
    |> Enum.zip(lengths)
    |> Enum.map(&format_value/1)
    |> Enum.join("  ")
    |> String.trim_trailing()
  end

  defp format_value({value, length}) when is_number(value) do
    value
    |> String.pad_leading(length)
  end
  defp format_value({value, length}) do
    value
    |> String.pad_trailing(length)
  end
end
