defmodule PISearcherTest do
  use ExUnit.Case

  import Ludolph.PISearcher

  test "ファイルが見つからない時エラーを返す" do
    assert_raise File.Error, fn ->
      scan("not_found.txt", "1234")
    end
  end

  test "指定した数列が見つからない" do
    assert scan("test/pi_5.txt", "999") == {:ng}
  end

  test "指定した数列が1つ見つかる" do
    assert scan("test/pi_5.txt", "5") == {:ok, 1}
  end

  test "指定した数列が複数個見つかる" do
    assert scan("test/pi_10000.txt", "888") == {:ok, 6}
  end
end
