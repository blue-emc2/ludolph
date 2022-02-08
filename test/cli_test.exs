defmodule CliTest do
  use ExUnit.Case
  doctest Ludolph

  import Ludolph.CLI, only: [parse_args: 1, process: 1]

  test "-hか--helpを指定したらヘルプが起動する" do
    assert parse_args(["-s", "-h"]) == :help
    assert parse_args(["-s", "--help"]) == :help
  end

  test "シングルモードで起動する" do
    assert parse_args(["-s", "/home/workspace/pi.txt", "-p", "1234"]) ==
             {:single, "1234", "/home/workspace/pi.txt"}
  end

  test "マルチモードで起動する" do
    assert parse_args(["-m", "/home/workspace/pi.txt", "-p", "1234"]) ==
             {:multi, "1234", "/home/workspace/pi.txt"}
  end

  test "シングルとマルチモードは共存できないのでヘルプが起動する" do
    assert parse_args(["-m", "-s", "/home/workspace/pi.txt"]) == :help
  end

  test "検索パターンが与えられなかったらヘルプが起動する" do
    assert parse_args(["-m", "/home/workspace/pi.txt", "1234"]) == :help
  end

  test "ファイルパスが与えられなかったらヘルプが起動する" do
    assert parse_args(["-s", "1234"]) == :help
  end

  describe "single mode" do
    test "10000けたの円周率を888で検索すると7個見つかる" do
      assert process({:single, "888", "test/pi_10000.txt"}) == "888は7個見つかりました"
    end
  end

  describe "multi mode" do
    test "10000けたの円周率を888で検索すると7個見つかる" do
      assert process({:multi, "888", "test/pi_10000.txt"}) == "888は7個見つかりました"
    end
  end
end
