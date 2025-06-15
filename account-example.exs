# # Ejemplos
#
#
# # 1 - Hola mundo bien pete
#
#
# # 2 - Hola mundo pero en un proceso hijo
#
#
# # 4 - Cuenta de banco
#
# defmodule Greet do
#   def greet() do
#     IO.puts "holi"
#   end
# end
#
# Greet.greet()
#
# # 3 - Hola mundo pero en un proceso "servidor". 
#
# defmodule Greeter do
#   def greeter() do
#     receive do
#       {:greetme, {sender, name}} -> send sender, "Hola señor #{name}"
#     end
#
#     greeter()
#   end
# end
#
# # 4 - Hola mundo pero en un proceso "servidor". Ahora con un ejemplo mas
#
# defmodule Greeter do
#   def greeter() do
#     receive do
#       {:greetme, {sender, name}} -> send sender, "Hola señor #{name}"
#       {:greetthem, {sender, name}} -> send sender, "Hola estimade #{name}"
#     end
#
#     greeter()
#   end
# end
#
# greeter_pid = spawn(Greeter, :greeter, [])
#
# send(greeter_pid, {:greetme, {self(), "Guille"}})
# send(greeter_pid, {:greetthem, {self(), "Joe Armstrong"}})
#
# receive do
#   msg -> IO.inspect msg
# end
#
# receive do
#   msg -> IO.inspect msg
# end
#
# defmodule Account do 
#
#   def account(balance) do
#     receive do
#
#       {sender, :deposit, amount} -> 
#         send  sender, {:ok, balance + amount}
#         account(balance + amount)
#
#       {sender, :withdraw, amount} ->
#         newBalance = balance - amount
#         if newBalance < 0 do
#           send sender, {:error, "No es posible retirar más que el balance, el balance actual es #{balance}"}
#           account(balance)
#         else
#           send  sender, {:ok, newBalance}
#           account(newBalance)
#         end
#     end
#   end
# end
#
# pid = spawn_link(Account, :account, [0])
#
# # send pid, {self(), :withdraw, 100}
# # send pid, {self(), :deposit, 100}
# # send pid, {self(), :withdraw, 100}
#
#
# defmodule Test do
#   def snd(send_to) do
#     send send_to, "queso"
#   end
#
#
#   def fst() do
#     pid = spawn(Test, :snd, [self()])
#
#     receive do
#       msg -> msg
#     end
#   end
#
#   def test() do
#     IO.inspect fst()
#   end
# end
#
# Test.test()



defmodule Account do 
  use GenServer

  def init(initial_balance) do
    { :ok, initial_balance }
  end

  def handle_call({:deposit, amount}, _from, balance) do
    { :reply, { :ok, balance + amount}, balance + amount}
  end

  def handle_call({:withdraw, amount}, _from, balance) do
      newBalance = balance - amount

      if newBalance < 0 do
        { :reply, {:error, "No es posible retirar más que el balance, el balance actual es #{balance}"}, balance}
      else
        { :reply, { :ok, newBalance }, newBalance }
      end
  end
end

{ :ok, pid } = GenServer.start_link(Account, 0, name: Account)

IO.inspect GenServer.call(Account, {:withdraw, 10})
IO.inspect GenServer.call(Account, {:deposit, 10})
IO.inspect GenServer.call(Account, {:withdraw, 10})
IO.inspect GenServer.call(Account, {:withdraw, "hola"})

