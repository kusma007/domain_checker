defmodule Checker.Supervisor do
  @moduledoc """
    Динамический супервизор, для создания подпроцессов чеккера
  """
  use DynamicSupervisor

  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  @spec init(any()) ::
          {:ok,
           %{
             extra_arguments: list(),
             intensity: non_neg_integer(),
             max_children: :infinity | non_neg_integer(),
             period: pos_integer(),
             strategy: :one_for_one
           }}
  def init(_arg) do
    # :one_for_one strategy: if a child process crashes, only that process is restarted.
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @doc """
    Добавляем процесс с доменом
  """
  @spec add_domain(any()) :: :ignore | {:error, any()} | {:ok, pid()} | {:ok, pid(), any()}
  def add_domain(domain) do
    DynamicSupervisor.start_child(__MODULE__, {Checker.Server, domain})
  end

end
