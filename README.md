# Ludolph

これは円周率のテキストファイルから任意の文字列を検索するコマンドラインツールです

## Usage

Usage: ludolph [option] <path> <pattern>

Options:

  -s single process
  -m multi process

## Example

ludolph [-s | -m] path/to/pi.txt 1234

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

