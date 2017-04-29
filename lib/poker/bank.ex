defmodule Poker.Bank do
  use GenServer
  
  # Client API
  
  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end
  
  def deposit(player, amount) do
    GenServer.call(__MODULE__, {:deposit, player, amount})
  end
  
  def withdraw(player, amount) do
    GenServer.call(__MODULE__, {:withdraw, player, amount})
  end
  
  def balance(player) do
    GenServer.call(__MODULE__, {:balance, player})
  end
  
  # Server callbacks
  
  def init(players), do: {:ok, players}
  
  def handle_call({:deposit, player, amount}, _from, players) when amount>= 0 do
    {:reply, :ok, Map.update(players, player, amount, fn current -> current + amount end)}
  end
  
  def handle_call({:withdraw, player, amount}, _from, players) when amount >= 0 do
    case Map.fetch(players, player) do
      {:ok, balance} when balance >= amount ->
        {:reply, :ok, Map.put(players, player, balance - amount)}
      _ ->
        {:reply, {:error, %{reason: :insufficient_funds}}, players}
    end
  end
      
  def handle_call({:balance, player}, _from, players) do
    case Map.fetch(players, player) do
      {:ok, balance} ->
        {:reply, balance, players}
      _ ->
        {:reply, 0, players}
    end
  end
      
  def handle_call(_msg, _from, players) do
    {:reply, :error, players}
  end
end