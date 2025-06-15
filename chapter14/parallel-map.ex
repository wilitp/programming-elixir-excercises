

defmodule ParallelMap do
  # pmap :: [a] -> (a -> b) -> [b]
  def pmap(collection, fun) do
    Enum.map(collection, fn elem -> spawn_link(__MODULE__, :apply_fun, [fun, elem, self()]) end)
    |> Enum.map(fn pid ->
      receive do
        {^pid, value} -> value
      end
    end)
  end

  def apply_fun(fun, elem, send_to) do
    send(send_to, {self(), fun.(elem)})
  end
end

f = fn x -> x+1 end

xs = [1,2,3]

IO.inspect ParallelMap.pmap(xs, f)
