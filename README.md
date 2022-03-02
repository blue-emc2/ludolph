# Ludolph

このコマンドラインツールは円周率が書かれたテキストファイルから任意の文字列を検索するツールです
検索文字列は円周率のみです

## Usage

Usage: ludolph [option] <path> <pattern>

Options:

  -s: シングルプロセスで検索します
  -m: マルチプロセスで検索します
  -j: マルチプロセス検索時のプロセス数を指定します（デフォルトは5）

Commands:

  ludolph -s path/to/pi.txt 1234
  ludolph -m path/to/pi.txt 1234
  ludolph -m -j 3 path/to/pi.txt 1234

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ludolph` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ludolph, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ludolph](https://hexdocs.pm/ludolph).

