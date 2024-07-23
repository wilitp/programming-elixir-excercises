# Use spawn_link to start a process, and have that process send a message to the parent and then exit immediately. Meanwhile, sleep for 500 ms in the parent, then receive as many messages as are waiting. Trace what you receive. Does it matter that you weren’t waiting for the notification from the child when it exited?

# Answer: the parent had no problem with the child exiting normally

defmodule WorkingWithMultipleProcesses4 do
  def child(parent) do
    exit(:ouch)
    send(parent, "hi dad")
  end

  def run() do
    spawn_link(__MODULE__, :child, [self()])

    :timer.sleep(500)

    receive do
      msg ->
        IO.puts(msg)
    end
  end
end
