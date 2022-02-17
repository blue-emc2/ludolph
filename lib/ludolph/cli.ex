defmodule Ludolph.CLI do

  alias Ludolph

  def main(argv) do
    argv
    |> parse_args()
    |> process()
  end

  def parse_args(argv) do
    parse =
      OptionParser.parse(argv,
        aliases: [s: :single, m: :multi, h: :help, p: :pattern],
        strict: [single: :boolean, multi: :boolean, help: :boolean, pattern: :string]
      )

    case parse do
      {[_, help: true], _path, _} -> :help
      {[single: true, multi: true, pattern: _], _path, _} -> :help
      {[single: true, pattern: pattern], path, _} -> {:single, pattern, List.first(path)}
      {[multi: true, pattern: pattern], path, _} -> {:multi, pattern, List.first(path)}
      _ -> :help
    end
  end

  def process(:help) do
    IO.puts("""
    usage: ludolph [-s | -m] path/to/pi.txt
    """)

    System.halt(0)
  end

  def process({:single, pattern, path}) do
    IO.puts("検索します")
    ret = Ludolph.Single.PISearcher.scan(path, pattern)
    case ret do
      0 -> IO.puts("#{pattern}は見つかりませんでした")
      ret -> IO.puts("#{pattern}は#{ret}個見つかりました")
    end
  end

  def process({:multi, pattern, path}) do
    parent = self()
    :global.register_name(:cli, parent)
    Ludolph.Multi.Application.start(:permanent , [pattern: pattern, path: path])

    receive do
      {:ok, count} -> IO.puts("#{pattern}は#{count}個見つかりました")
      {:ng} -> IO.puts("#{pattern}は見つかりませんでした")
    end
  end
end
