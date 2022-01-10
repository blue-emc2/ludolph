defmodule Ludolph.CLI do
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
    Ludolph.PISearcher.scan(pattern, path)

    System.halt(0)
  end

  def process({:multi, _pattern, _path}) do
    System.halt(0)
  end
end
