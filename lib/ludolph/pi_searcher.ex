defmodule Ludolph.PISearcher do
  def scan(path, pattern) do
    Stream.resource(
      fn -> File.open!(path) end,
      fn file ->
        case IO.read(file, :all) do
          data when is_binary(data) -> {[data], file}
          _ -> {:halt, file}
        end
      end,
      fn file -> File.close(file) end
    )
    |> _scan(pattern)
  end

  defp _scan(stream, _pattern) do
    pi =
      stream
      |> Enum.take(1)
      |> List.first()
      |> String.trim()
      |> String.graphemes()

    # 検索ロジックは後で

    {:ok, 0}
  end
end
