defmodule Ludolph.Single.PISearcher do
  def scan(path, pattern) do
    File.stream!(path, [], :line)
    |> Stream.flat_map(fn s -> String.split(s, "", trim: true) end)
    |> Stream.chunk_every(1000)
    |> Stream.map(fn chunk ->
      chunk
      |> count_up(pattern)
    end)
    |> Enum.to_list()
    |> Enum.reduce(0, fn x, acc -> x + acc end)
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
            # TODO: 余裕があったら桁数も集計する
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
