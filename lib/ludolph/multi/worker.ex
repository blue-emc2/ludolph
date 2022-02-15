defmodule Ludolph.Multi.Worker do
  # このworkerが正常に停止した場合、スーパーバイザーはworkerを再起動せず、失敗した場合のみ再起動するというオプション
  use GenServer, restart: :transient

  alias Ludolph.Multi

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args)
  end

  def init(:no_args) do
    Process.send_after(self(), :search, 0)

    {:ok, nil}
  end

  def handle_info(:search, _) do
    # Menagerから次の1000桁をもらい、検索結果を積める
    {numbers, pattern} = Multi.Manager.next_numbers(1000)
    add_result(numbers, pattern)
  end

  # 検索終了
  defp add_result(:eof, _pattern) do
    Multi.Gatherer.done()
    {:stop, :normal, nil}
  end

  # 検索すべき数列がまだ残っている
  defp add_result(numbers, pattern) do
    number_list = String.codepoints(numbers)
    Multi.Gatherer.result(match_count(number_list, pattern))

    send(self(), :search)

    {:noreply, nil}
  end

  defp match_count(list, pattern) do
    [head | _tail] = String.codepoints(pattern)

    indexes =
      Enum.with_index(list)
      |> Enum.reduce([], fn {n, index}, acc ->
        if(n == head) do
          # 次の数と次のパターン文字を探す
          ret =
            Enum.slice(list, index, String.length(pattern))
            |> numeric_list_match(pattern)

          case ret do
            {:ok} -> [index | acc]
            {:ng} -> acc
          end
        else
          acc
        end
      end)

    length(indexes)
  end

  defp numeric_list_match(list, patterns) do
    if Enum.join(list) == patterns do
      {:ok}
    else
      {:ng}
    end
  end
end
