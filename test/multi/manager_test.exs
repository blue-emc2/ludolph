defmodule Multi.ManagerTest do
  use ExUnit.Case

  alias Ludolph.Multi.Manager

  test "next_numbersを呼び出すと3桁づつ返ってくる" do
    Manager.start_link(path: "test/pi_30.txt", pattern: "123")

    assert Manager.next_numbers(3) == {"012", "123"}
    assert Manager.next_numbers(3) == {"345", "123"}
    assert Manager.next_numbers(3) == {"678", "123"}
  end

  test "読み込む桁が中途半端でも必要な分だけ返してくれる" do
    Manager.start_link(path: "test/pi_30.txt", pattern: "1234")

    assert Manager.next_numbers(22) == {"0123456789012345678901", "1234"}
    assert Manager.next_numbers(10) == {"23456789\n", "1234"}
  end

  test "ファイルが存在しない場合、エラーメッセージを表示する" do
    assert_raise File.Error, fn ->
      Manager.init(path: "test/not_found.txt", pattern: "1234")
    end
  end
end
