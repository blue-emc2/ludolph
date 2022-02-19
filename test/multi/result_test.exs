defmodule Ludolph.Multi.ResultsTest do
  use ExUnit.Case

  alias Ludolph.Multi.Results

  test "検索結果をためて取り出すとマージされて返ってくる" do
    Results.start_link(:no_args)

    Results.add(5)
    Results.add(15)
    Results.add(25)
    Results.add(35)

    results = Results.get()

    assert length(results) == 4
    assert 15 in results
  end
end
