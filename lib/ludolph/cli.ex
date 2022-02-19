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
        aliases: [s: :single, m: :multi, h: :help],
        strict: [single: :boolean, multi: :boolean, help: :boolean]
      )

    case parse do
      {[_, help: true], _, _} -> :help
      {[single: true, multi: true], _, _} -> :help
      {[single: true], [path, pattern], _} -> {:single, path, pattern}
      {[multi: true], [path, pattern], _} -> {:multi, path, pattern}
      _ -> :help
    end
  end

  def process(:help) do
    IO.puts("""
    Usage: ./ludolph [-s | -m] path/to/pi.txt 1234
    """)

    System.halt(0)
  end

  def process({:single, path, pattern}) do
    IO.puts("シングルプロセスで検索します")
    ret = Ludolph.Single.PISearcher.scan(path, pattern)

    case ret do
      0 -> IO.puts("#{pattern}は見つかりませんでした")
      count -> IO.puts("#{pattern}は#{count}個見つかりました")
    end
  end

  def process({:multi, path, pattern}) do
    IO.puts("マルチプロセスで検索します")
    parent = self()
    :global.register_name(:cli, parent)
    Ludolph.Multi.Application.start(:permanent, path: path, pattern: pattern)

    receive do
      0 -> IO.puts("#{pattern}は見つかりませんでした")
      count -> IO.puts("#{pattern}は#{count}個見つかりました")
    end
  end
end
