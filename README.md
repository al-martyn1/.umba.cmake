**Информация о документе**

**Описание**: Небольшой наборчик костыльных хелперов для CMake.

**URL**: https://github.com/al-martyn1/umba-md-pp/blob/main/.umba.cmake/README.md

---

# UMBA CMake (umba.cmake)

Небольшой наборчик костыльных хелперов для CMake.

- [Быстрый старт](#быстрый-старт)
- [Конфигурационные переменные](#конфигурационные-переменные)
- [Функции](#функции)
  - [Функция umba_add_target_options](#функция-umba_add_target_options)
  - [Функция umba_make_sources_tree](#функция-umba_make_sources_tree)
  - [Функция umba_configure_boost](#функция-umba_configure_boost)
- [Замечания по использованию внешних библиотек](#замечания-по-использованию-внешних-библиотек)
  - [Boost](#boost)
    - [Boost в режиме header-only](#boost-в-режиме-header-only)
    - [Настройка системы для использования Boost в режиме header-only](#настройка-системы-для-использования-boost-в-режиме-header-only)
    - [Использование Boost в режиме FetchContent](#использование-boost-в-режиме-fetchcontent)
- [Справка по использованию подмодулей](#справка-по-использованию-подмодулей)


# Быстрый старт

Добавление в проект целиком, как подмодуль:
```
git submodule add https://github.com/al-martyn1/.cmake.git
```

Добавление в проект только файла `umba.cmake` (находимся в подкаталоге `.cmake` проекта):
```
wget https://raw.githubusercontent.com/al-martyn1/.cmake/main/umba.cmake
```

# Конфигурационные переменные

Конфигурационные переменные следует задавать до подключения данного (`umba.cmake`) файла.

 - `UMBA_STATIC_RUNTIME` - использовать статический рантайм при сборке приложения.


# Функции


## Функция umba_add_target_options

Используется для настройки исполняемого файла.

```cmake
function(umba_add_target_options TARGET OPTIONS...)
```

`OPTIONS` - список опций настройки, опции могут принимать следующие значения:
 - `UNICODE` - создавать UNICODE приложение;
 - `CONSOLE` - создавать консольное приложение;
 - `WINDOWS` - создавать оконное приложение;
 - `BIGOBJ` - используется при наличии большой базы шалонного/inline кода;
 - `UTF8` - использовать кодировку UTF8 в исходниках.


## Функция umba_make_sources_tree

Используется, чтобы разложить исходники по группам "Sources"/"Headers"/"Resources".
Применяется при генерации в проектные файлы MSVS (или аналогичные).

```cmake
function(umba_make_sources_tree SRC_ROOT SRCS HDRS RCSRCS)
```

Аргументы:
 - `SRC_ROOT` - корень, относительно которого будут формироваться имена в дереве;
 - `SRCS` - файлы с исходными текстами;
 - `HDRS` - заголовочные файлы;
 - `RCSRCS` - файлы ресурсов.

Если что-то не задано, то следует вставить пустое значение `""`.


## Функция umba_configure_boost

Используется для настройки библиотеки `Boost` в режиме `FetchContent`.

```cmake
function(umba_configure_boost BOOST_OPTIONS...)
```

`BOOST_OPTIONS` - список опций настройки, опции могут принимать следующие значения:
 - `STATIC_LIBS` - использовать статические библиотеки;
 - `MULTITHREADED` - использовать многопоточную версию библиотеки;
 - `SINGLETHREADED` - использовать одноопоточную версию библиотеки;
 - `STATIC_RUNTIME` - использовать статически линкуемый C/C++ рантайм.


# Замечания по использованию внешних библиотек

## Boost

Для использования библиотек `Boost` надо перед подключением данного файла включить использование `Boost`:

```cmake
set(UMBA_USE_BOOST ON)

include(${CMAKE_CURRENT_LIST_DIR}/.cmake/umba.cmake)

```

### Boost в режиме header-only

При включении использования библиотеки `Boost` по умолчанию включается режим
использования header-only библиотек.

Для указания месторасположения библиотеки Boost следует задать переменную `Boost_INCLUDE_DIR`:
```cmake
set(Boost_INCLUDE_DIR "Path/to/boost")
```

Можно один раз задать в системе переменную окружения `BOOST_ROOT`, и если
переменная `Boost_INCLUDE_DIR` явно не задаётся в вашем `CMakeLists.txt`, то её значение будет получено из
переменной окружения `BOOST_ROOT`.


### Настройка системы для использования Boost в режиме header-only

Для использования библиотек `Boost` в режиме header-only требуется скачать
архив оффициального релиза - [boost_1_85_0.zip](https://archives.boost.io/release/1.85.0/source/boost_1_85_0.zip)
(или в любом другом формате архива [отсюда](https://www.boost.org/users/history/version_1_85_0.html)).

Скачанный архив следует разархивировать, например, в каталог `D:\boost_1_85_0`.

После этого следует установить переменную окружения `BOOST_ROOT`:
```
BOOST_ROOT=D:\boost_1_85_0
```

### Использование Boost в режиме FetchContent

В данном режиме вся библиотека `Boost` подключается в текущий проект,
и к использованию становятся доступны все библиотеки, в т.ч. и те, которые требуют компиляции
из исходных кодов.

Данный режим включается установкой переменной `UMBA_USE_BOOST_FETCH` до включения данного файла:
```cmake
set(UMBA_USE_BOOST ON)
set(UMBA_USE_BOOST_FETCH ON)

include(${CMAKE_CURRENT_LIST_DIR}/.cmake/umba.cmake)
```

Данный режим тратит довольно много времени на скачивание и конфигурирование библиотеки `Boost` каждый раз
при генерации сборочных скриптов (до нескольких минут).

В переменной `UMBA_BOOST_CMAKE_FETCH_URL` можно задать адрес архива для скачивания.
По умолчанию используется адрес архива `https://github.com/boostorg/boost/releases/download/boost-1.85.0/boost-1.85.0-cmake.tar.xz`.

Если переменная `UMBA_BOOST_CMAKE_FETCH_URL` не задана, производится попытка получить адрес архива из
переменной окружения `BOOST_CMAKE_FETCH_URL`.

Для того, чтобы исключить обращение к сети при каждой генерации файлов сборки, можно сохранить этот файл локально:
```
cd d:
d:
wget https://github.com/boostorg/boost/releases/download/boost-1.85.0/boost-1.85.0-cmake.tar.xz
```

После чего задать переменную окружения `BOOST_CMAKE_FETCH_URL`:
```cmake
BOOST_CMAKE_FETCH_URL=d:\boost-1.85.0-cmake.tar.xz
```

Можно явно задать URL архива для режима FetchContent:
```cmake
set(UMBA_USE_BOOST ON)
set(UMBA_USE_BOOST_FETCH ON)
set(UMBA_BOOST_CMAKE_FETCH_URL "d:/boost-1.85.0-cmake.tar.xz")

include(${CMAKE_CURRENT_LIST_DIR}/.cmake/umba.cmake)
```


# Справка по использованию подмодулей

Pro Git : [Инструменты Git - Подмодули](https://git-scm.com/book/ru/v2/%D0%98%D0%BD%D1%81%D1%82%D1%80%D1%83%D0%BC%D0%B5%D0%BD%D1%82%D1%8B-Git-%D0%9F%D0%BE%D0%B4%D0%BC%D0%BE%D0%B4%D1%83%D0%BB%D0%B8)


При клонировании проекта надо выполнить:
```
# для инициализации локального конфигурационного файла
git submodule init
# для получения всех данных этого проекта и извлечения соответствующего коммита,
# указанного в основном проекте.
git submodule update 
```

Для автоматической инициализации и подтягивания подмодулей при клонировании проекта можно выполнить:
```
git clone --recurse-submodules https://github.com/al-martyn1/.cmake.git
```

При обновлении существующего проекта до версии с подмодулями выполняем:
```
git submodule update --init
# или
git submodule update --init --recursive
```

Обновляем проект с подмодулями так:
```
git submodule update --remote
# или
git submodule update --recursive --remote
# или
git submodule update --init --recursive --remote --merge
```


