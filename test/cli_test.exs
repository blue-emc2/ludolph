defmodule Ludolph.CliTest do
  use ExUnit.Case

  import Ludolph.CLI, only: [parse_args: 1, process: 1]
  import ExUnit.CaptureIO

  test "-hか--helpを指定したらヘルプが起動する" do
    assert parse_args(["-s", "-h"]) == :help
    assert parse_args(["-s", "--help"]) == :help
  end

  test "シングルモードで起動する" do
    assert parse_args(["-s", "/home/workspace/pi.txt", "1234"]) ==
             {:single, "/home/workspace/pi.txt", "1234"}
  end

  test "マルチモードで起動する" do
    assert parse_args(["-m", "/home/workspace/pi.txt", "1234"]) ==
             {:multi, 5, "/home/workspace/pi.txt", "1234"}
  end

  test "シングルとマルチモードは共存できないのでヘルプが起動する" do
    assert parse_args(["-m", "-s", "/home/workspace/pi.txt", "1234"]) == :help
  end

  test "シングルでジョブ数は指定できないのでヘルプが起動する" do
    assert parse_args(["-s", "-j", "3", "/home/workspace/pi.txt", "1234"]) == :help
  end

  test "検索パターンが与えられなかったらヘルプが起動する" do
    assert parse_args(["-m", "/home/workspace/pi.txt"]) == :help
  end

  test "ファイルパスが与えられなかったらヘルプが起動する" do
    assert parse_args(["-s", "1234"]) == :help
  end

  describe "single mode" do
    test "10000けたの円周率を888で検索すると7個見つかる" do
      ret = capture_io(fn ->
        process({:single, "test/pi_10000.txt", "888"})
      end)

      assert ret == """
      シングルプロセスで検索します
      888は7個見つかりました
      """
    end
  end

  describe "multi mode" do
    test "10000けたの円周率を888で検索すると7個見つかる" do
      ret = capture_io(fn ->
        process({:multi, 1, "test/pi_10000.txt", "888"})
      end)

      assert ret == """
      マルチプロセスで検索します
      888は7個見つかりました
      """
    end
  end
end
