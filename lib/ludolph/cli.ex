defmodule Ludolph.CLI do
  def run(argv) do
    parse_args(argv)
  end

  def parse_args(argv) do
    parse =
      OptionParser.parse(argv,
        aliases: [s: :single, m: :multi, h: :help],
        strict: [single: :boolean, multi: :boolean, help: :boolean]
      )

    case parse do
      {[_, help: true], _path, _} -> :help
      {[single: true, multi: true], _path, _} -> :help
      {[single: true], path, _} -> {:single, List.first(path)}
      {[multi: true], path, _} -> {:multi, List.first(path)}
      _ -> :help
    end
  end
end
