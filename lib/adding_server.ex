defmodule Checker.AddingServer do
  @moduledoc """
    Сервер получения запросов на проверку доменов и хранения пачки доменов
  """
  use GenServer

  @limit 10
  # use list = []

  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(_) do
    GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  end

  @impl true
  @spec init(any()) :: {:ok, any()}
  def init(state), do: {:ok, state}

  @doc """
    Возвращает список доменов в очереди
  """
  @spec get() :: any()
  def get, do: GenServer.call(__MODULE__, :get)
  # def add(domain), do: GenServer.cast(__MODULE__, {:add, domain})

  @doc """
    Добавляем домен в очередь, если доменов не больше лимита,
    в противном случае отправляем статус :max
  """
  @spec add(any()) :: any()
  def add(domain), do: GenServer.call(__MODULE__, {:add, domain})

  @doc """
    Очистка хранилища
  """
  @spec clear() :: :ok
  def clear, do: GenServer.cast(__MODULE__, :clear)

  @impl true
  def handle_call(:get, _from, state) do
    # length(state) |> IO.inspect()
    {:reply, state, state}
  end

  def handle_call({:add, domain}, _, state) do
    # length(state) |> IO.inspect()
    if(length(state) >= @limit) do
      {:reply, :max, [state]}
    else
      {:reply, :ok, [domain | state]}
    end
  end

  @impl true
  def handle_cast(:clear, _) do
    {:noreply, []}
  end

end
