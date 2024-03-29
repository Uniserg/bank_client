# Клиентское приложение для банка

## Как использовать

**Шаг 1:**

Загрузите или клонируйте этот репозиторий, используя ссылку ниже:

```
https://github.com/Uniserg/bank_client.git
```

**Шаг 2:**

Перейдите в корень проекта и выполните следующую команду в консоли, чтобы получить необходимые зависимости:

```
flutter pub get 
```

**Шаг 3:**

Этот проект использует библиотеку `json_serializable`, которая работает с генерацией кода, выполните следующую команду для создания файлов:

```
flutter packages pub run build_runner build --delete-conflicting-outputs
```

или команду watch для автоматической синхронизации исходного кода:

```
flutter packages pub run build_runner watch
```

## Скрыть сгенерированные файлы

В Visual Studio Code перейдите в `Preferences` -> `Settings` и найдите `Files:Exclude`. Добавьте следующие шаблоны:
```
**/*.inject.summary
**/*.inject.dart
**/*.g.dart
```

## Функционал приложения

* просмотр доступных продуктов в системе;
* авторизации/регистрации пользователей;
* заказ банковской карты для авторизованных пользователей;
* просмотр статуса заказа;
* создание и резервирование банковского счета и карты;
* управление статусом заявки для роли оператора посредством запроса;
* просмотр реквизитов счета и карты;
* просмотр профиля;
* перевод денежных средств внутри банка по номеру карты;
* перевод денежных средств внутри банка по номеру телефона;
* просмотр операций по счету;
* уведомления о денежном переводе.

## GIF

![](https://github.com/Uniserg/bank_client/blob/master/shared/registration.gif)
![](https://github.com/Uniserg/bank_client/blob/master/shared/card_order.gif)
![](https://github.com/Uniserg/bank_client/blob/master/shared/money_transfer_by_card_number.gif)
![](https://github.com/Uniserg/bank_client/blob/master/shared/money_transfer_by_phone_number.gif)
