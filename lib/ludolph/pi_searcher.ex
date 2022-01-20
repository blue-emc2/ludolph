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
  end

  # 3.14の点を抜いた数列
  defp get_numeric_list(stream) do
    Enum.to_list(stream)
      |> List.flatten()
      |> List.delete_at(1)
  end

  defp count_up(list, pattern) do
    [head | tail] = String.codepoints(pattern)

    count =
      Enum.with_index(list)
      |> Enum.reduce(0, fn {n, index}, acc ->
        if(n == head) do
          # 次の数と次のパターン文字を探す
          c = _count_up(list, index, tail, 1, 1)
          acc + c
        else
          acc
        end
      end)

    case count do
      0 -> {:ng}
      _ -> {:ok, count}
    end
  end

  defp _count_up(list, index, pattern, pindex, acc) do
    n = Enum.at(list, index)
    p = Enum.at(pattern, pindex)

    cond do
      n == "\n" || is_nil(p) -> acc
      n != p -> 0
      n == p -> 1
    end
  end
end
