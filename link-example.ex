defmodule LinkExmaple do
  # import :timer, [{:only, [{:sleep, 1}]}] <- ugly explicit associative list

  # <- cool version
  import :timer, only: [sleep: 1]

  def exiting_function do
    sleep(500)
    exit(:bad)
  end

  def run do
    spawn_link(__MODULE__, :exiting_function, [])
  end
end

