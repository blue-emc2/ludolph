defmodule Ludolph.PISearcher do
  def scan(path, pattern) do
    Stream.resource(
      fn -> File.open!(path) end,
      fn file ->
        case IO.read(file, 1) do
          data when is_binary(data) -> {[data], file}
          _ -> {:halt, file}
        end
      end,
      fn file -> File.close(file) end
    )
    # とりあえず10分割する
    |> Stream.chunk_every(10)
    |> get_numeric_list()
    |> count_up(pattern)
    |> result()
  end

  # 3.14の点を抜いた数列
  defp get_numeric_list(stream) do
    Enum.to_list(stream)
    |> List.flatten()
    |> List.delete_at(1)
  end

  defp result(count) do
    case count do
      0 -> {:ng}
      _ -> {:ok, count}
    end
  end

  defp count_up(list, pattern) do
    [head | _tail] = String.codepoints(pattern)

    indexes =
      Enum.with_index(list)
      |> Enum.reduce([], fn {n, index}, acc ->
        if(n == head) do
          # 次の数と次のパターン文字を探す
          ret =
            Enum.slice(list, index, String.length(pattern))
            |> numeric_list_match(pattern)

          case ret do
            {:ok} -> [index | acc]
            {:ng} -> acc
          end
        else
          acc
        end
      end)

    length(indexes)
  end

  defp numeric_list_match(list, patterns) do
    if Enum.join(list) == patterns do
      {:ok}
    else
      {:ng}
    end
  end
end
