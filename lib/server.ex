defmodule Checker.Server do
  @moduledoc """
    Основная часть обработки каждого домена, в отдельном процессе
  """
  use GenServer

  @timeout 5

  ## Серверная часть

  def child_spec(process_name) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [process_name]},
      restart: :transient
    }
  end

  @doc """
    Инициализируем и возвращаем таймаут, что бы перезапускался процесс
  """
  @impl true
  @spec init(any()) :: {:ok, any(), non_neg_integer()}
  def init(name) do
    {:ok, name, :timer.seconds(@timeout)}
  end


  @doc """
    Функция добавления процесса в супервизор,
    добавляем домен в хранилище и стартуем процесс
  """
  @spec start_link(binary()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(domain) do
    domain |> save_domain

    GenServer.start_link(__MODULE__, domain, name: {:global, domain})
  end

  @doc """
    Функция срабатывания процесса, где обновляем и проверяем домен
  """
  @impl true
  def handle_info(:timeout, state) do
    state |> save_domain

    {:noreply, state, :timer.seconds(@timeout)}
  end


  ## Функции работы с доменами


  @doc """
    Удаляем домен из хранилища и останавливаем процесс
  """
  @spec remove_domain(any()) :: :not_find | :ok
  def remove_domain(domain) do
    :ets.delete(:domains, domain)
    try do
      GenServer.stop({:global, domain}, :normal)
    catch
      :exit, _ -> :not_find
    end
  end

  @doc """
    Сохраняем домен в хранилище
  """
  @spec save_domain(binary()) :: true
  def save_domain(domain) do
    :ets.insert(:domains, {domain, :os.system_time(:second), check_domain(domain)})
  end


  @doc """
    Проверяем статус домена
  """
  @spec check_domain(binary()) :: :error | :ok
  def check_domain(domain) do
    # ping_random()
    # domain |> ping_socket
    domain |> ping_http
  end

  @doc """
    Рандомный статус
  """
  @spec ping_random() :: :error | :ok
  def ping_random() do
    if :rand.uniform(100) > 50 do :ok else :error end
  end

  @doc """
    Проверка статуса домена через http
  """
  @spec ping_http(binary()) :: :error | :ok
  def ping_http(domain) do
    HTTPoison.start
    {status, _} = HTTPoison.get(domain)
    status
  end

  @doc """
    Проверка статуса домена через сокет
  """
  @spec ping_socket(binary() | URI.t()) :: :error | :ok
  def ping_socket(domain) do
    result = domain |> URI.parse
    cond do
      result.host |> is_nil ->
        connect_sock(~c(#{result.path}), 443)
      result.port |> is_nil ->
        connect_sock(~c(#{result.host}), 443)
      true ->
        connect_sock(~c(#{result.host}), result.port)
    end
  end

  @doc """
    Конектимся к домену по порту
  """
  @spec connect_sock(
          atom()
          | list()
          | {:local, binary() | list()}
          | {byte(), byte(), byte(), byte()}
          | {char(), char(), char(), char(), char(), char(), char(), char()},
          char()
        ) :: :error | :ok
  def connect_sock(domain, port) do
    {status, _} = :gen_tcp.connect(domain, port, [:binary, active: false], 300)
    status
  end
end
