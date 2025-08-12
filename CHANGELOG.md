<table>
<tr>
<td>
<details open lang="en">
<summary>English</summary>

### [0.1.4.3 α — 2025-08-?? (upcoming update)](https://github.com/DemerNkardaz/DSL-KeyPad/releases/tag/0.1.4.3)

- Additions:

  - Addded missed cyrillic characters:
    - [ Ӫ ӫ ]
  - Addded missed latin characters:
    - [ ᶴ ]
  - Added support for new Latin layouts:
    - Workman, Halmak, Norman, AZERTY default/local variants, Canary, Asset, JCUKEN, Graphite, Gallium, Nerps, Sturdy, Stronk, Dhorf, PanQWERTY (Own), Qwickly
  - Added support for new Cyrillic layouts:
    - ЯШЕРТЫ
  - Added new Latin bindings:
    - “RAlt LAlt LShift RShift N” → “Ɲɲ”

- Changes:

  - Tray menu: Added display of bindings for few commands.
  - Symbols 『』 moved to “RAlt LAlt LShift CapsLock On []” bind.
  - Binding “RAlt RShift N”: characters “Ɲɲ” replaced with “Ŋŋ”.
  - Submenu “Layouts” in tray now has columns for Latin, Cyrillic and Hellenic characters.
  - Variant selection for locale now moved directly to Locale.Read() method.

- Fixes:

  - Disabled update check error message during background update checking.
  - Fixed minor localization mistakes.
  - Fixed mistake in recipes for “ꭂ” and “ꭁ” symbols.
  - Fixed incorrect url to change log.
  - Removed erroneous tabulation in the ‱ symbol’s LaTeX command.
  - Fixed missing Shift remapping of letter-keys for keyboard layouts.
  - Fixed mistake in “Ɏ”, “Ꞑ” bindings.

### [0.1.3.2 α — 2025-07-25](https://github.com/DemerNkardaz/DSL-KeyPad/releases/tag/0.1.3.2)

- First full release of “DSL KeyPad”.

- Main features:

  - Support for inputting over 4,700 Unicode symbols.
  - Multi-layer keyboard bindings for symbol input.
    - Support for custom bindings.
  - “Composition” mode for converting character sequences into other characters.
    - Support for custom sequences.
  - “Alternative input” — additional binding sets for various writing systems.
  - “Glyph variations” — a set of modes for inputting symbol variants (A — 𝐴𝙰𝕬…).
  - TELEX/VNI-like input processor for Vietnamese (with Jarai symbols) and for Pinyin.
  - Search and insert system for symbols by their tags.
  - Internal keyboard layouts with support for custom layouts.
  - Support for modifications.

</details>
</td>
<td>
<details open lang="ru">
<summary>Русский</summary>

### [0.1.4.3 α — 2025-08-?? (предстоящее обновление)](https://github.com/DemerNkardaz/DSL-KeyPad/releases/tag/0.1.4.3)

- Дополнения:

  - Добавлены пропущенные символы кириллицы:
    - [ Ӫ ӫ ]
  - Добавлены пропущенные символы латиницы:
    - [ ᶴ ]
  - Добавлена поддержка новых раскладок латиницы:
    - Workman, Halmak, Norman, стандартный/локальный вариант AZERTY, Canary, Asset, JCUKEN, Graphite, Gallium, Nerps, Sturdy, Stronk, Dhorf, PanQWERTY (Собственная), Qwickly
  - Добавлена поддержка новых раскладок кириллицы:
    - ЯШЕРТЫ
  - Добавлены новые привязки латиницы:
    - «RAlt LAlt LShift RShift N» → «Ɲɲ»

- Изменения:

  - Меню трея: Добавлено отображение привязок для некоторых команд.
  - Символы 『』 перемещены на привязку «RAlt LAlt LShift CapsLock On []».
  - Привязка «RAlt RShift N»: символы «Ɲɲ» заменены на «Ŋŋ».
  - Подменю «Раскладки» в трее теперь имеет вид колонок для латиницы, кириллицы и эллиницы.
  - Выбор варианта локали теперь перенесён непосредственно в метод Locale.Read().

- Исправления:

  - Отключено сообщение об ошибке проверки обновлений при фоновой проверке обновлений.
  - Исправлены мелкие ошибки локализации.
  - Исправлены ошибки в рецептах символов «ꭂ» и «ꭁ».
  - Исправлена некорректная ссылка на журнал изменений.
  - Удалена ошибочная табуляция в LaTeX-команде символа ‱.
  - Исправлены отсутствующие переназначения буквенных клавиш на Shift для клавиатурных раскладок.
  - Исправлена ошибка в привязках для ввода «Ɏ», «Ꞑ».

### [0.1.3.2 α — 2025-07-25](https://github.com/DemerNkardaz/DSL-KeyPad/releases/tag/0.1.3.2)

- Первый полноценный релиз «DSL KeyPad».

- Основные возможности:

  - Поддержка ввода более 4 700 символов Юникода.
  - Многослойные клавиатурные привязки для ввода символов.
    - Поддержка пользовательких привязок.
  - Режим «Композиции» для конверсии последовательности символов в другой символ.
    - Поддержка пользовательских последовательностей.
  - «Альтернативный ввод» — дополнительные наборы привязок для различных форм письменности.
  - «Вариации глифа» — набор режимов для ввода вариантов символа (A — 𝐴𝙰𝕬…).
  - TELEX/VNI-подобный процессор ввода для Вьетнамского языка (с символами Джарайского) и для Пиньиня.
  - Система поиска и вставки символов по их тегам.
  - Внутренние раскладки клавиатуры с поддержкой пользовательских разметок.
  - Поддержка модификаций.

</details>
</td>
</tr>
</table>
