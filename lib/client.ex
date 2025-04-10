defmodule Checker.Client do
  @moduledoc """
    Основной модуль управлением проверками доменов
    Добавление, удаление и просмотр статусов доменов
  """


  @doc """
    Добавляем домен и запускаем проверку
  """
  @spec add(binary()) :: :ignore | {:error, any()} | {:ok, pid()} | {:ok, pid(), any()}
  def add(domain), do:
    domain |> clear_domain |> Checker.Supervisor.add_domain()

  @doc """
    Добавляем домены из файла и запускаем проверки по всем
  """
  @spec add_from_file(
          binary()
          | maybe_improper_list(
              binary() | maybe_improper_list(any(), binary() | []) | char(),
              binary() | []
            )
        ) :: :ok
  def add_from_file(file) do
    file |> get_from_file |> Enum.each(fn item -> item |> add end)
  end

  # Получаем массив доменов из файла
  defp get_from_file(file) do
    case file |> File.read() do
      {:ok, file_string} -> file_string
        |> String.split("\n")
        |> Enum.map( fn item -> item
        |> String.trim end)
        |> Enum.filter(fn item -> item != "" end)
      {:error, _} -> []
    end
  end

  @doc """
    Удаляем домен из хранилища и останавливаем процесс
  """
  @spec remove(binary()) :: :not_find | :ok
  def remove(domain), do:
    domain |> clear_domain |> Checker.Server.remove_domain()

  @doc """
    Удаляем все домены из хранилища и останавливаем все процессы
  """
  @spec remove() :: :ok
  def remove do
    get_all() |> Enum.each(fn item ->
      [{domain, _, _}] = item
      domain |> remove()
    end)
  end

  # Очистка домена от лишних символов
  defp clear_domain(domain),
    do: domain |> String.trim

  @doc """
    Просмотр записей отфильтрованных по статусу, или поиск по домену
  """
  @spec status(any()) :: list() | %{optional(<<_::48, _::_*8>>) => any()}
  def status(:error) do
    status() |> filter_by_status(:error)
  end

  def status(:ok) do
    status() |> filter_by_status(:ok)
  end

  def status(domain) do
    :ets.lookup(:domains, domain) |> format_row
  end

  @doc """
    Показываем состояние всех доменов их хранилища
  """
  @spec status() :: list()
  def status do
    get_all() |> Enum.map(fn item -> item |> format_row end)
  end

  @doc """
    Фильтруем все записи по статусу
  """
  @spec filter_by_status(any(), any()) :: list()
  def filter_by_status(items, status) do
    items |> Enum.filter(fn item -> item["status"] == status end)
  end

  # Форматируем строку из хранилища в Maps
  defp format_row(item) do
    [{domain, time, status}] = item
    %{"domain" => domain, "updated" => time |> DateTime.from_unix!() |> DateTime.to_naive(), "status" => status}
  end

  # Берём все записи из хранилища
  defp get_all do
    :ets.match(:domains, :"$1")
  end

end
