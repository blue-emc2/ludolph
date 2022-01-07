defmodule LudolphTest do
  use ExUnit.Case
  doctest Ludolph

  import Ludolph.CLI, only: [parse_args: 1]

  test "-hか--helpを指定したら:helpが取得できる" do
    assert parse_args(["-s", "-h"]) == :help
    assert parse_args(["-s", "--help"]) == :help
  end

  test "-sとfilepathを指定したらキーワードリストが取得できる" do
    assert parse_args(["-s", "/home/workspace/pi.txt"]) == {:single, "/home/workspace/pi.txt"}
  end

  test "-mとfilepathを指定したらキーワードリストが取得できる" do
    assert parse_args(["-m", "/home/workspace/pi.txt"]) == {:multi, "/home/workspace/pi.txt"}
  end

  test "-sと-mを両方指定したら:helpが取得できる" do
    assert parse_args(["-m", "-s", "/home/workspace/pi.txt"]) == :help
  end
end
