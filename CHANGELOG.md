<table>
<tr>
<td>
<details open lang="en">
<summary>English</summary>

### [0.1.5.3 α — (upcoming release)](https://github.com/DemerNkardaz/DSL-KeyPad/releases/tag/0.1.5.3)

- Additions:

  - Library extended to 5,400+ Unicode characters.
  - Addded missed latin characters:
    - [ ȷ ɟ ʄ ᶡ 𐞘 ]
  - Addded missed miscellaneous characters:
    - [ ⸸ ⸶ ⸷ ] [ ⹀ ⹝ ⸗ ]
  - Added support for new Latin layouts:
    - Blaze, Canary (Ortho variant), Engrammer, Focal, Pine v4, Rain, Recurva
  - Added support for new Cyrillic layouts:
    - Kharlamak, Rulemak (2018)
  - Added new Alternative modes:
    - Imperial Aramaic, Manichaean, Samaritan
  - Added new Glyphs variations:
    - Regional Indicator, Circled, Double Circled, Negative Circled, Parenthesized, Squared, Negative Squared, with Dot, with Comma, Tags
  - Added new options:
    - “Scripter” selector: max items per page/max columns/threshold for max columns now can be customized via settings window.
  - Added function for conversion between symbols and tag-symbols.
  - Added information about converters to the “Help” tab.
  - Added more “mirror” Shift combinations and their description in the “Help” tab.
  - “Help” info for roman numerals mode extended.
  - Added “ToolTipOptions” external library, allowing changing the appearance of tooltips. https://www.autohotkey.com/boards/viewtopic.php?f=83&t=113308
  - Added options for “Compose” customization.

- Changes:

  - Noto Sans and Noto Sans Symbols now required fonts.
  - Suggestion to download missing required fonts now opens the corresponding Google Fonts page instead of downloading the TTF file from GitHub.
  - Format for referencing variables/function calls inside strings for the parser changed from %…% to <% … %/>.
  - Tooltips (including the “Composition” mode) now use the Noto Sans font.
  - Wallet, Miscellaneous, Alchemical, Astrololigical symbol sets reordered.

- Fixes:

  - Fixed “Compositing” mode crash with “?” recipes.
  - Fixed a mistake where the small letter [ ꚋ ] was actually capital [ Ꚋ ].

---

### [0.1.4.3 α — 2025-08-15](https://github.com/DemerNkardaz/DSL-KeyPad/releases/tag/0.1.4.3)

- Additions:

  - Library extended to 4,900+ Unicode characters.
  - Addded missed cyrillic characters:
    - [ Ӫ ӫ ] [ Ӿ ӿ Ѝ ѝ Ӳ ӳ ᲅ ᲆ ᲄ ᲀ ᲂ ᲃ ᲁ ҂ ]
  - Addded missed latin characters:
    - [ ᶴ ] [ Ꜩ ꜩ ] [ ꝱ ꝲ ꝳ ꝴ ꝶ ꝵ ꝷ ꝸ ] [ Ꝫ ꝫ Ꝭ ꝭ Ꝯ ꝯ ꝰ ] [ Ꝇ ꝇ ]
  - Addded missed miscellaneous characters:
    - [ ₠ ]
  - Added support for new Latin layouts:
    - Workman, Halmak, Norman, AZERTY default/local variants, Canary, Asset, JCUKEN, Graphite, Gallium, Nerps, Sturdy, Stronk, Dhorf, PanQWERTY (Own), Qwickly
  - Added support for new Cyrillic layouts:
    - ЯШЕРТЫ
  - Added new Latin bindings:
    - “RAlt LAlt LShift RShift N” → “Ɲɲ”
  - Added new Alternative modes:
    - Aghwan (Caucasian Albanian), Inscriptional Parthian, Palmyrene

- Changes:

  - Tray menu: Added display of bindings for few commands.
  - Symbols 『』 moved to “RAlt LAlt LShift CapsLock On []” bind.
  - Binding “RAlt RShift N”: characters “Ɲɲ” replaced with “Ŋŋ”.
  - Submenu “Layouts” in tray now has columns for Latin, Cyrillic and Hellenic characters.
  - Variant selection for locale now moved directly to Locale.Read() method.
  - Recipe “et” of symbol “&” changed to “amp” to release “et” for symbol “Ꝫ” (Latin letter Et).
  - IPA and Math Alternative modes moved to the top of selector for faster access.

- Fixes:

  - Disabled update check error message during background update checking.
  - Fixed minor localization mistakes.
  - Fixed mistake in recipes for “ꭂ” and “ꭁ” symbols.
  - Fixed incorrect url to change log.
  - Removed erroneous tabulation in the ‱ symbol’s LaTeX command.
  - Fixed missing Shift remapping of letter-keys for keyboard layouts.
  - Fixed mistake in “Ɏ”, “Ꞑ” bindings.
  - Fixed displaying numerals of some scripts in the “Scripts” tab list.

---

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

### [0.1.5.3 α — (предстоящий релиз)](https://github.com/DemerNkardaz/DSL-KeyPad/releases/tag/0.1.5.3)

- Дополнения:

  - Библиотека расширена до 5,400+ символов Unicode.
  - Добавлены пропущенные символы латиницы:
    - [ ȷ ɟ ʄ ᶡ 𐞘 ]
  - Добавлены пропущенные прочие символы:
    - [ ⸸ ⸶ ⸷ ] [ ⹀ ⹝ ⸗ ]
  - Добавлена поддержка новых раскладок латиницы:
    - Blaze, Canary (Ortho вариант), Engrammer, Focal, Pine v4, Rain, Recurva
  - Добавлена поддержка новых раскладок кириллицы:
    - Харламак, Рулемак (2018)
  - Добавлены новые Альтернативные режимы:
    - Имперское арамейское, Манихейское, Самаритянское письмо
  - Добавлены новые Вариации глифов:
    - Региональные индикаторы, в круге, двойном круге, закрашенном круге, скобках, квадрате, закрашенном квадратке, с точкой и с запятой, теги
  - Добавлены новые настройки:
    - Селектор «скриптера»: макс. элементов на странице/макс. колонок/порог макс. колонок теперь могут быть настроены через окно настроек.
  - Добавлена функция конвертации между символами и тег-символами.
  - Добавлена информация о конвертерах во вкладку «Помощь».
  - Добавлено больше «зеркальных Shift-комбинаций» и описание их во вкладке «Помощь».
  - Расширена информация во вкладке «Помощь» о режиме ввода римских чисел.
  - Добавлена сторонняя библиотека «ToolTipOptions», позволяющая изменять вид всплывающих подсказок. https://www.autohotkey.com/boards/viewtopic.php?f=83&t=113308
  - Добавлены настройки для кастомизации режима «Композиции».

- Изменения:

  - Noto Sans и Noto Sans Symbols теперь обязательные шрифты.
  - Предложение скачать отсутствующие обязательные шрифты теперь открывает соответствующую страницу Google Fonts вместо загрузки TTF-файла с GitHub.
  - Формат записи ссылок на переменные/вызовы функций внутри строк для парсера изменены с %…% на <% … %/>.
  - Всплывающие подсказки (в том числе режима «Композиции») теперь используют шрифт «Noto Sans».
  - Изменён порядок для наборов валютных, алхимических, астрологических и других разных символов.

- Исправления:

  - Исправлена остановка режима «Композиции» с рецептами символа «?».
  - Исправлена ошибка, когда строчный символ [ ꚋ ] на самом деле был прописным [ Ꚋ ].

---

### [0.1.4.3 α — 2025-08-15](https://github.com/DemerNkardaz/DSL-KeyPad/releases/tag/0.1.4.3)

- Дополнения:

  - Библиотека расширена до 4,900+ символов Unicode.
  - Добавлены пропущенные символы кириллицы:
    - [ Ӫ ӫ ] [ Ӿ ӿ Ѝ ѝ Ӳ ӳ ᲅ ᲆ ᲄ ᲀ ᲂ ᲃ ᲁ ҂ ]
  - Добавлены пропущенные символы латиницы:
    - [ ᶴ ] [ Ꜩ ꜩ ] [ ꝱ ꝲ ꝳ ꝴ ꝶ ꝵ ꝷ ꝸ ] [ Ꝫ ꝫ Ꝭ ꝭ Ꝯ ꝯ ꝰ ] [ Ꝇ ꝇ ]
  - Добавлены пропущенные прочие символы:
    - [ ₠ ]
  - Добавлена поддержка новых раскладок латиницы:
    - Workman, Halmak, Norman, стандартный/локальный вариант AZERTY, Canary, Asset, JCUKEN, Graphite, Gallium, Nerps, Sturdy, Stronk, Dhorf, PanQWERTY (Собственная), Qwickly
  - Добавлена поддержка новых раскладок кириллицы:
    - ЯШЕРТЫ
  - Добавлены новые привязки латиницы:
    - «RAlt LAlt LShift RShift N» → «Ɲɲ»
  - Добавлены новые Альтернативные режимы:
    - Агванское, Парфянское, Пальмирское письмо

- Изменения:

  - Меню трея: Добавлено отображение привязок для некоторых команд.
  - Символы 『』 перемещены на привязку «RAlt LAlt LShift CapsLock On []».
  - Привязка «RAlt RShift N»: символы «Ɲɲ» заменены на «Ŋŋ».
  - Подменю «Раскладки» в трее теперь имеет вид колонок для латиницы, кириллицы и эллиницы.
  - Выбор варианта локали теперь перенесён непосредственно в метод Locale.Read().
  - Рецепт «et» символа «&» изменён на «amp» для освобождения «et» для символа «Ꝫ» (Latin letter Et).
  - МФА и Математический Альтернативные режимы перемещены в начало селектора для более быстрого доступа.

- Исправления:

  - Отключено сообщение об ошибке проверки обновлений при фоновой проверке обновлений.
  - Исправлены мелкие ошибки локализации.
  - Исправлены ошибки в рецептах символов «ꭂ» и «ꭁ».
  - Исправлена некорректная ссылка на журнал изменений.
  - Удалена ошибочная табуляция в LaTeX-команде символа ‱.
  - Исправлены отсутствующие переназначения буквенных клавиш на Shift для клавиатурных раскладок.
  - Исправлена ошибка в привязках для ввода «Ɏ», «Ꞑ».
  - Исправлено отображение чисел некоторых письменностей в списке вкладки «Письменности».

---

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
