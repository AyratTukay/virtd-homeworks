# Домашнее задание к занятию 5. «Практическое применение Docker» Тукаев Айрат

---
## Примечание: Ознакомьтесь со схемой виртуального стенда [по ссылке](https://github.com/netology-code/shvirtd-example-python/blob/main/schema.pdf)

---

## Задача 0
1. Убедитесь что у вас НЕ(!) установлен ```docker-compose```, для этого получите следующую ошибку от команды ```docker-compose --version```
```
Command 'docker-compose' not found, but can be installed with:

sudo snap install docker          # version 24.0.5, or
sudo apt  install docker-compose  # version 1.25.0-1

See 'snap info docker' for additional versions.
```
В случае наличия установленного в системе ```docker-compose``` - удалите его.  
2. Убедитесь что у вас УСТАНОВЛЕН ```docker compose```(без тире) версии не менее v2.24.X, для это выполните команду ```docker compose version```  

**Выполнение:**  
  В системе установлена ```docker compose``` версии Docker Compose version v5.1.3.
  ![Скрин команд](img/img1.png)

---

## Задача 1
1. Сделайте в своем GitHub пространстве fork [репозитория](https://github.com/netology-code/shvirtd-example-python).

2. Создайте файл ```Dockerfile.python``` на основе существующего `Dockerfile`:
   - Используйте базовый образ ```python:3.12-slim```
   - Обязательно используйте конструкцию ```COPY . .``` в Dockerfile
   - Создайте `.dockerignore` файл для исключения ненужных файлов
   - Используйте ```CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5000"]``` для запуска
   - Протестируйте корректность сборки
2.1 Используйте multistage сборку вместо single stage.
3. (Необязательная часть, *) Изучите инструкцию в проекте и запустите web-приложение без использования docker, с помощью venv. (Mysql БД можно запустить в docker run).
4. (Необязательная часть, *) Изучите код приложения и добавьте управление названием таблицы через ENV переменную.
---
### ВНИМАНИЕ!
!!! В процессе последующего выполнения ДЗ НЕ изменяйте содержимое файлов в fork-репозитории! Ваша задача ДОБАВИТЬ 5 файлов: ```Dockerfile.python```, ```compose.yaml```, ```.gitignore```, ```.dockerignore```,```bash-скрипт```. Если вам понадобилось внести иные изменения в проект - вы что-то делаете неверно!
---

**Выполнение:**  
 Создал файл ```Dockerfile.python``` на основе существующего `Dockerfile` согласно рекомендациям.  
 [Ссылка](https://github.com/AyratTukay/shvirtd-example-python/tree/main)



## Задача 2 (*)
1. Создайте в yandex cloud container registry с именем "test" с помощью "yc tool" . [Инструкция](https://cloud.yandex.ru/ru/docs/container-registry/quickstart/?from=int-console-help)
2. Настройте аутентификацию вашего локального docker в yandex container registry.
3. Соберите и залейте в него образ с python приложением из задания №1.
4. Просканируйте образ на уязвимости.
5. В качестве ответа приложите отчет сканирования.

**Выполнение:**  
 Создал в yandex cloud container registry с именем "test". После настройки залил в него образ с python и просканировал на уязвимости.  
   ![Скрин сканирования](img/img2.png)

## Задача 3
1. Изучите файл "proxy.yaml"
2. Создайте в репозитории с проектом файл ```compose.yaml```. С помощью директивы "include" подключите к нему файл "proxy.yaml".
3. Опишите в файле ```compose.yaml``` следующие сервисы: 

- ```web```. Образ приложения должен ИЛИ собираться при запуске compose из файла ```Dockerfile.python``` ИЛИ скачиваться из yandex cloud container registry(из задание №2 со *). Контейнер должен работать в bridge-сети с названием ```backend``` и иметь фиксированный ipv4-адрес ```172.20.0.5```. Сервис должен всегда перезапускаться в случае ошибок.
Передайте необходимые ENV-переменные для подключения к Mysql базе данных по сетевому имени сервиса ```web``` 

- ```db```. image=mysql:8. Контейнер должен работать в bridge-сети с названием ```backend``` и иметь фиксированный ipv4-адрес ```172.20.0.10```. Явно перезапуск сервиса в случае ошибок. Передайте необходимые ENV-переменные для создания: пароля root пользователя, создания базы данных, пользователя и пароля для web-приложения.Обязательно используйте уже существующий .env file для назначения секретных ENV-переменных!

2. Запустите проект локально с помощью docker compose , добейтесь его стабильной работы: команда ``````curl -L http://127.0.0.1:8090 должна возвращать в качестве ответа время и локальный IP-адрес. Если сервисы не стартуют воспользуйтесь командами: ```docker ps -a ``` и ```docker logs <container_name>``` . Если вместо IP-адреса вы получаете информационную ошибку --убедитесь, что вы шлете запрос на порт ```8090```, а не 5000.

5. Подключитесь к БД mysql с помощью команды ```docker exec -ti <имя_контейнера> mysql -uroot -p<пароль root-пользователя>```(обратите внимание что между ключем -u и логином root нет пробела. это важно!!! тоже самое с паролем) . Введите последовательно команды (не забываем в конце символ ; ): ```exit use <имя вашей базы данных(по-умолчанию virtd, как это указано в .env)>; show tables; SELECT * from requests LIMIT 10;```. Примечание: таблица в БД создается после первого поступившего запроса к приложению.

6. Остановите проект. В качестве ответа приложите скриншот sql-запроса.

**Выполнение:**  
  Создал в репозитории с проектом файл ```compose.yaml```. С помощью директивы "include" подключил к нему файл "proxy.yaml". Запустил проект локально с помощью docker compose. В ответ на команду ```curl -L http://127.0.0.1:8090``` получаю ошибку ```curl: (7) Failed to connect to 127.0.0.1 port 8090 after 0 ms: Could not connect to server```. Никак не могу добиться роботоспособности.  
   ![Скрин 1](img/img3.png)
   ![Скрин 2](img/img4.png)
   ![Скрин 3](img/img5.png)

   Результат ```docker logs web```:
   ```
   Traceback (most recent call last):
  File "/app/venv/lib/python3.12/site-packages/uvicorn/protocols/http/httptools_impl.py", line 426, in run_asgi
    result = await app(  # type: ignore[func-returns-value]
             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/app/venv/lib/python3.12/site-packages/uvicorn/middleware/proxy_headers.py", line 84, in __call__
    return await self.app(scope, receive, send)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/app/venv/lib/python3.12/site-packages/fastapi/applications.py", line 1106, in __call__
    await super().__call__(scope, receive, send)
  File "/app/venv/lib/python3.12/site-packages/starlette/applications.py", line 122, in __call__
    await self.middleware_stack(scope, receive, send)
  File "/app/venv/lib/python3.12/site-packages/starlette/middleware/errors.py", line 184, in __call__
    raise exc
  File "/app/venv/lib/python3.12/site-packages/starlette/middleware/errors.py", line 162, in __call__
    await self.app(scope, receive, _send)
  File "/app/venv/lib/python3.12/site-packages/starlette/middleware/exceptions.py", line 79, in __call__
    raise exc
  File "/app/venv/lib/python3.12/site-packages/starlette/middleware/exceptions.py", line 68, in __call__
    await self.app(scope, receive, sender)
  File "/app/venv/lib/python3.12/site-packages/fastapi/middleware/asyncexitstack.py", line 20, in __call__
    raise e
  File "/app/venv/lib/python3.12/site-packages/fastapi/middleware/asyncexitstack.py", line 17, in __call__
    await self.app(scope, receive, send)
  File "/app/venv/lib/python3.12/site-packages/starlette/routing.py", line 718, in __call__
    await route.handle(scope, receive, send)
  File "/app/venv/lib/python3.12/site-packages/starlette/routing.py", line 276, in handle
    await self.app(scope, receive, send)
  File "/app/venv/lib/python3.12/site-packages/starlette/routing.py", line 66, in app
    response = await func(request)
               ^^^^^^^^^^^^^^^^^^^
  File "/app/venv/lib/python3.12/site-packages/fastapi/routing.py", line 274, in app
    raw_response = await run_endpoint_function(
                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/app/venv/lib/python3.12/site-packages/fastapi/routing.py", line 193, in run_endpoint_function
    return await run_in_threadpool(dependant.call, **values)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/app/venv/lib/python3.12/site-packages/starlette/concurrency.py", line 41, in run_in_threadpool
    return await anyio.to_thread.run_sync(func, *args)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/app/venv/lib/python3.12/site-packages/anyio/to_thread.py", line 33, in run_sync
    return await get_asynclib().run_sync_in_worker_thread(
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/app/venv/lib/python3.12/site-packages/anyio/_backends/_asyncio.py", line 877, in run_sync_in_worker_thread
    return await future
           ^^^^^^^^^^^^
  File "/app/venv/lib/python3.12/site-packages/anyio/_backends/_asyncio.py", line 807, in run
    result = context.run(func, *args)
             ^^^^^^^^^^^^^^^^^^^^^^^^
  File "/app/main.py", line 103, in index
    with get_db_connection() as db:
         ^^^^^^^^^^^^^^^^^^^
  File "/usr/local/lib/python3.12/contextlib.py", line 137, in __enter__
    return next(self.gen)
           ^^^^^^^^^^^^^^
  File "/app/main.py", line 46, in get_db_connection
    db = mysql.connector.connect(
         ^^^^^^^^^^^^^^^^^^^^^^^^
  File "/app/venv/lib/python3.12/site-packages/mysql/connector/pooling.py", line 293, in connect
    return CMySQLConnection(*args, **kwargs)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/app/venv/lib/python3.12/site-packages/mysql/connector/connection_cext.py", line 129, in __init__
    self.connect(**kwargs)
  File "/app/venv/lib/python3.12/site-packages/mysql/connector/abstracts.py", line 1237, in connect
    self._open_connection()
  File "/app/venv/lib/python3.12/site-packages/mysql/connector/connection_cext.py", line 313, in _open_connection
    raise get_mysql_exception(
mysql.connector.errors.DatabaseError: 2003 (HY000): Can't connect to MySQL server on '127.20.0.10:3306' (111)

What's next:
    View and search logs for all containers in one place
    with Docker Desktop's Logs view. docker-desktop://dashboard/logs
   ```

  Результат ```docker logs db```:  
   ![Скрин 4](img/img6.png)

  Результат ```docker logs shvirtd-example-python-ingress-proxy-1```:  
   ![Скрин 5](img/img7.png)
  
  Результат ```docker logs shvirtd-example-python-reverse-proxy-1```:  
   ![Скрин 6](img/img8.png)
  
 Подскажите что я делаю не так, где можно почитать?

## Задача 4
1. Запустите в Yandex Cloud ВМ (вам хватит 2 Гб Ram).
2. Подключитесь к Вм по ssh и установите docker.
3. Напишите bash-скрипт, который скачает ваш fork-репозиторий в каталог /opt и запустит проект целиком.
4. Зайдите на сайт проверки http подключений, например(или аналогичный): ```https://check-host.net/check-http``` и запустите проверку вашего сервиса ```http://<внешний_IP-адрес_вашей_ВМ>:8090```. Таким образом трафик будет направлен в ingress-proxy. Трафик должен пройти через цепочки: Пользователь → Internet → Nginx → HAProxy → FastAPI(запись в БД) → HAProxy → Nginx → Internet → Пользователь
5. (Необязательная часть) Дополнительно настройте remote ssh context к вашему серверу. Отобразите список контекстов и результат удаленного выполнения ```docker ps -a```
6. Повторите SQL-запрос на сервере и приложите скриншот и ссылку на fork.

## Задача 5 (*)
1. Напишите и задеплойте на вашу облачную ВМ bash скрипт, который произведет резервное копирование БД mysql в директорию "/opt/backup" с помощью запуска в сети "backend" контейнера из образа ```schnitzler/mysqldump``` при помощи ```docker run ...``` команды. Подсказка: "документация образа."
2. Протестируйте ручной запуск
3. Настройте выполнение скрипта раз в 1 минуту через cron, crontab или systemctl timer. Придумайте способ не светить логин/пароль в git!!
4. Предоставьте скрипт, cron-task и скриншот с несколькими резервными копиями в "/opt/backup"

## Задача 6
Скачайте docker образ ```hashicorp/terraform:latest``` и скопируйте бинарный файл ```/bin/terraform``` на свою локальную машину, используя dive и docker save.
Предоставьте скриншоты  действий .

## Задача 6.1
Добейтесь аналогичного результата, используя docker cp.  
Предоставьте скриншоты  действий .

## Задача 6.2 (**)
Предложите способ извлечь файл из контейнера, используя только команду docker build и любой Dockerfile.  
Предоставьте скриншоты  действий .

## Задача 7 (***)
Запустите ваше python-приложение с помощью runC, не используя docker или containerd.  
Предоставьте скриншоты  действий .
