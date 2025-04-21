defmodule Checker.CheckingServer do
  @moduledoc """
    Сервер проверяющий пачку доменов по таймауту.
  """
  alias Checker.{AddingServer, Server}
  use GenServer
  @timeout 500

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  @impl true
  @spec init(any()) :: {:ok, any(), number()}
  def init(state), do: {:ok, state, @timeout}

  @doc """
    Проверка статусов пачки доменов
  """
  def check() do
    # :os.system_time(:second) |> IO.inspect()
    # AddingServer.get() |> IO.inspect()
    AddingServer.get() |> Enum.each(fn item ->
      item |> Server.save_domain(item |> Server.check_domain) end)
    # :timer.sleep(1000)
    AddingServer.clear()
  end

  @impl true
  def handle_info(:timeout, state) do
    check()
    {:noreply, state, @timeout}
  end
end
