# Чеккер доменов

## Установка

```
git clone https://github.com/kusma007/domain_checker.git

mix deps.get
```

## Запуск

``` iex -S mix ``` или ``` iex --erl "-kernel shell_history enabled" -S mix ```

### 1) Необходимо добавить добавить домены

#### Добавить один домен

```
Checker.Supervisor.add_domain(domain)
example
Checker.Supervisor.add("asys.xt-xarid.uz")
```

#### Добавить домены из файла

```
Checker.Supervisor.add_from_file(file)

example
Checker.Supervisor.add_from_file("domains_test.txt")
Checker.Supervisor.add_from_file("domains.txt")
```

### 2) Просмотр статуса проверок

#### Просмотр всех доменов
```
Checker.Supervisor.status()
```

#### Просмотр рабочих доменов
```
Checker.Supervisor.status(:ok)
```

#### Просмотр не рабочих доменов
```
Checker.Supervisor.status(:error)
```

#### Просмотр статуса определённого домена
```
Checker.Supervisor.status(domain)
example
Checker.Supervisor.status("asys.xt-xarid.uz")
```


### 3) Удаление проверок

#### Удаление одного домена из проверок
```
Checker.Supervisor.remove(domain)
example
Checker.Supervisor.remove("asys.xt-xarid.uz")
```

#### Удаление всех проверок
```
Checker.Supervisor.remove()
```