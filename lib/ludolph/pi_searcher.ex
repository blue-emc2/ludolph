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
    |> _scan(pattern)
  end

  defp _scan(stream, pattern) do
    [head | _tail] =
      String.codepoints(pattern)
      |> Enum.map(fn s -> String.to_integer(s) end)

    # 3.14の点を抜いた
    numeric_list =
      Enum.to_list(stream)
      |> List.flatten()
      |> Enum.join()
      |> String.trim()
      |> String.replace(".", "")
      |> String.codepoints()

    count =
      for n <- numeric_list, reduce: 0 do
        acc ->
          if(String.to_integer(n) == head) do
            acc + 1
          else
            acc
          end
      end

    case count do
      0 -> {:ng}
      _ -> {:ok, count}
    end
  end
end
