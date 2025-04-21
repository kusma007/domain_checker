defmodule Checker.Application do
  @spec start(any(), any()) :: {:error, any()} | {:ok, pid()}
  def start(_type, _args) do

    :ets.new(:domains, [:set, :public, :named_table])

    children = [
      {Checker.Supervisor, []},
      Checker.AddingServer,
      Checker.CheckingServer,
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)

  end
end
