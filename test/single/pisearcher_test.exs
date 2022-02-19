defmodule PISearcherTest do
  use ExUnit.Case

  import Ludolph.Single.PISearcher

  test "ファイルが見つからない時エラーを返す" do
    assert_raise File.Error, fn ->
      scan("not_found.txt", "1234")
    end
  end

  test "指定した数列が見つからない" do
    assert scan("test/pi_5.txt", "999") == 0
  end

  test "指定した数列が1つ見つかる" do
    assert scan("test/pi_5.txt", "5") == 1
  end

  test "指定した数列が複数個見つかる" do
    # "8888"は2つとしてカウントする
    assert scan("test/pi_10000.txt", "888") == 7
  end
end
