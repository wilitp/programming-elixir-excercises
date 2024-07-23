
defmodule ChainCounter do

  def chain_node(send_to) do
    receive do
      i -> send(send_to, i + 1)
    end
  end

  def fire(n) do
    pid = Enum.reduce(1..n, self(), fn _el, acc -> spawn(__MODULE__, :chain_node, [acc]) end)

    send pid, 0

    receive do
      i ->
        IO.puts i
    end
    
  end
end


