
defmodule Account.Server do 
  use GenServer

  def start_link(balance) do
    GenServer.start_link(__MODULE__, balance, name: __MODULE__)
  end

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
