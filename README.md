[![OpenYellow](https://img.shields.io/endpoint?url=https://openyellow.org/data/badges/4/802981082.json)](https://openyellow.org/grid?data=top&repo=802981082)

# Подсиcтема "PAPI"

<img src="./assets/img/png/PAPIVK.png?raw=true" width="250">

### Материалы по "PAPI":

- [Telegram канал разработчика](https://t.me/dsdred_thinkings)
- 💤[YouTube](https://www.youtube.com/playlist?list=PLmaAvH9kGsqr3UvWtL-oXqcwVRLXcuZTG) `На паузе из-за блокировок`
- [VK.Видео](https://vk.com/video/playlist/168885665_4) `Скоро`
- [Релизы PAPI](https://github.com/dsdred/PAPI/releases)

<details>
<summary>
<b>Примеры по подсистеме PAPI</b>
</summary>

- [[Примеры] Подсистема PAPI. Часть 1](https://infostart.ru/1c/articles/1105206/) - В статье рассмотрены Методы и Алгоритмы.
- [[Обновление] Подсистема PAPI версия 0.9.2.6 с примерами](https://infostart.ru/1c/articles/2175170/) - В статье рассмотрены изменения в релизе 0.9.2.6.
- [[Обновление] Подсистема PAPI версия 0.9.3](https://infostart.ru/1c/tools/2216535/) - В статье рассмотрены изменения в релизе 0.9.3.1
</details>

<details>
<summary>
<b>Состав релизов</b>
</summary>

**demoVxxx.zip** - Содержит файлы демонстрационных возможностей подсистемы.

- **dt** - Содержит базу demo.dt с демо данными.
- **cfe** - Содержит расширение ЛокализацияPAPI.cfe с дополнительными объектами, использованными в демо примерах.
- **additional** - Содержит различные обработки из примеров.
  - **ДемоПодпискиНаСобытияДляPAPI.epf** - обработка с примерами подписок на события.
  - **ДемоПодпискиНаСобытияИКомандыДляPAPI.epf** - Обработка с примерами подписок на событие и командами.
  - **ДемоПримерыPAPI.epf** - в обработке содержатся примеры взаимодействия с Алгоритмами.
  - **ДемоПримерыАлгоритмовPAPI.epf** - Содержит пример вызова внешнего Алгоритма.
  - **ДемоПримерыМетодовPAPI.epf** - Содержит пример взаимодействия методов с внешней обработкой.

**releaseVxxx.zip** - Содержит релиз подсистемы PAPI.

- **additional** - Содержит вспомогательные обработки.
  - **ПодпискиНаСобытияДляPAPI.epf** - Обработка с пред заполненными подписками на события.
- **cfe** - Содержит расширения:
  - **ЛокализацияPAPI.cfe** - Пустое расширение, служит как вспомогательное расширение.
  - **ПодсистемаPAPI_x_x_x_x.cfe** - Последняя версия PAPI.
  </details>

<details>
<summary>
<b>Карта репозитория</b>
</summary>

**assets** - Ресурсы, вспомогательные файлы.

**documentation** - Содержит документацию.

**src** - Содержит исходники расширения ПодсистемаPAPI последней версии.

- **ПодсистемаPAPIzip** - Содержит файл с архивом исходников.
- **ПодсистемаPAPI** - Содержит файлы исходников.

</details>

## О подсистеме

**PAPI (Pretty API)** – подсистема разрабатывалась как универсальный http-сервис, но в ходе разработки обросла и другими инструментами. Подсистема с полностью открытым кодом.
Разрабатывается на платформе 8.3.24, в текущий момент в бою крутится в режиме совместимости 8.3.17.

### Состав подсистемы PAPI

**Подсистема.PAPI** - Основная подсистема

- **Общие модули**

  - **PAPI_АсинхронныеОперации** - код выполняемый в фоне. Удаление старых данных, обновление и т.д.
  - **PAPI_ДанныеДляЗаполненияНастроек** - данные требуемые по умолчанию.
  - **PAPI_Логирование** - логирование в журнал регистрации основных действий.
  - **PAPI_ОбщегоНазначенияВызовСервера** - различные процедуры и функции общего назначения.
  - **PAPI_ОбщегоНазначенияГлобальный** - различные процедуры и функции общего назначения.
  - **PAPI_ОбщегоНазначенияКлиент** - различные процедуры и функции общего назначения.
  - **PAPI_ОбщегоНазначенияКлиентСервер** - различные процедуры и функции общего назначения.
  - **PAPI_ФайловаяСистемаКлиентАсинх** - модуль по работе с файлами.

- **Роли**

  - **PAPI_Администратор** - полные права.
  - **PAPI_БазовыеПрава** - минимальные права.
  - **PAPI_ПодсистемаPAPI** - видимость подсистемы PAPI.
  - **PAPI_Оператор** - чтение данных из различных регистров, для устранения ошибок.

- **Регламентные задания**

  - **PAPI_УдалениеСтарыхДанных** - удаление устаревших данных.

- **Общие команды**

  - **PAPI_Настройки** - открывает форму настроек подсистемы.

- **Общие формы**

  - **PAPI_Настройки** - форму настроек подсистемы.

- **Общие картинки**

  - **PAPI** - картинка подсистемы.
  - **PAPI_Метаданные** - иконки метаданных. Используется при построении дерева метаданных.
  - **PAPI_Часы** - песочные часы при длительных операциях.

- **Константы**

  - **PAPI_НастройкаХраненияДанных** - хранилище значений, содержит структуру с настройками для чистки старых данных.
  - **PAPI_ТекущаяВерсия** - версия требуется при обновлении на релизы.

- **Перечисления**

  - **PAPI_ТипЛога** - требуется для записи логов.
  - **PAPI_СрокиХранения** - требуется для механизмов чистки данных.

- [Подсистема.PAPI_ИсторияДанных](/documentation/datahistory.md)

- **Подсистема.PAPI_ВычисляемыеПодсистемы** - Содержит подсистемы с выполняемым кодом
  - [Подсистема.Алгоритмы](/documentation/algorithms.md)
