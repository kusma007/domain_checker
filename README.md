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
Checker.Client.add(domain)
example
Checker.Client.add("asys.xt-xarid.uz")
```

#### Добавить домены из файла

```
Checker.Client.add(file)

example
Checker.Client.add("domains_test.txt")
Checker.Client.add("domains.txt")
```

### 2) Просмотр статуса проверок

#### Просмотр всех доменов
```
Checker.Client.status()
```

#### Просмотр рабочих доменов
```
Checker.Client.status(:ok)
```

#### Просмотр не рабочих доменов
```
Checker.Client.status(:error)
```

#### Просмотр статуса определённого домена
```
Checker.Client.status(domain)
example
Checker.Client.status("asys.xt-xarid.uz")
```


### 3) Удаление проверок

#### Удаление одного домена из проверок
```
Checker.Client.remove(domain)
example
Checker.Client.remove("asys.xt-xarid.uz")
```

#### Удаление всех проверок
```
Checker.Client.remove()
```