<table>
<tr>
<td>
<details open lang="en">
<summary>English</summary>

### [0.1.8.3 α — 2025-?-?](https://github.com/DemerNkardaz/DSL-KeyPad/releases/tag/0.1.8.3)

- Additions:

  - Addded new Astrological characters:
    - [ ⛎︎ ]
  - Addded new Glagolitic characters:
    - [ ⰯⱟⰥⱕ ]
  - Addded new Hellenic characters:
    - [ ϶ ]
  - Addded new miscellaneous characters:
    - [ ⧼⧽ ⫽ ⫻ ◌⃫ ]

- Changes:

  - Binds for IPA tone bars moved from right Alt to left (to keep ⟨⟩ on the original right Alt + 9/0 combination).
  - Removed long recipe versions for symbols of Alchemy, Astrology and Astronomy (due to their lack of relevance and violation of the “Composition” mode concept).

- Fixes:

  - Fixed wrong parenthesis in TELEX/VNI-like tooltip.

---

### [0.1.7.3 α — 2025-10-04](https://github.com/DemerNkardaz/DSL-KeyPad/releases/tag/0.1.7.3)

- Additions:

  - Library extended to 6,300+ Unicode characters.
  - Added symbol sets: Yin and Yang (☯︎); monograms, bigrams, trigrams and hexagrams of Yijing; monograms, bigrams and tetragrams of Taixuanjing; Majiang tiles/dices; Xiangqi pieces; Domino tiles.
  - Extended Chess symbols set.
  - Added segmented variants of numbers, outlined variants A-Z letters and numbers.
  - Added new Alternative modes:
    - Yijing & Taixuanjing.
  - Addded new IPA characters:
    - [ ˥ ˦ ˧ ˨ ˩ ꜒ ꜓ ꜔ ꜕ ꜖ ꜈ ꜉ ꜊ ꜋ ꜌ ꜍ ꜎ ꜔ ꜐ ꜑ ]
  - Addded new miscellaneous characters:
    - [ ¦ ⸨⸩ ⹉ ⹍ ⹎ ⸚ ⸛ ⸞ ⸟ ⹊  ⸜⸝ ⸌⸍ ⹕⹖ ⹗⹘ ] [ 🙶🙷🙸🙻🙺🙹 ] [ 𐆠 𐆐𐆑𐆒𐆓𐆔𐆕𐆛𐆜 ]

- Changes:

  - When searching for tags, if the query does not contain a space, it now looks for the presence of a whole word before proceeding with other comparison options.
  - Titltes/tags generation for symbols entries, also “Search” and filtering in main window was improved.
  - “Compose” mode now accepts both normal characters and surrogate pairs.
  - Main window’s tabs now have a separate list element for displaying all symbols and a separate list for displaying search results (now there is no need to fill the list again when the search is canceled).
  - “Enter” key in “Compose” mode now allows to confirm any input. If the recipe was not completed, the input field will contain the entered sequence.

- Fixes:

  - Fixed Windows 11 error, when symbols are ignored in the “Compositions” mode.
  - Fixed “Compose” mode crash with typing “()[]+” symbols.

### [0.1.6.3 α — 2025-09-29](https://github.com/DemerNkardaz/DSL-KeyPad/releases/tag/0.1.6.3)

- Additions:

  - Library extended to 5,800+ Unicode characters.
  - Bundle of Alchemical, Astrological, Astronomical symbols was reworked and extended.
  - Added the Sixteen Figures of Geomancy.
  - Added Chess, Card Suits and Playing Cards symbols.
  - Addded new latin characters:
    - [ 𐞥 𐞀 ⁱ ] [ ꟱ ᶧ ᵾ ᵿ] [ ꜣ Ꜣ ꜥ Ꜥ (Egyptological Alef and Ain) ]
  - Addded new IPA characters:
    - [ 𐞁 𐞂 ]
  - Addded new miscellaneous characters:
    - [ ⸢ ⸣ ⸤ ⸥ ] [ ꜛ ꜜ ] [ ℥ ℈ ℀ ℁ ⅍ ℅ ℆ ℄ ] [ ℣ ℟ ] [ ◌͞ ◌͟ ◌͝ ]
  - IPA characters now have dedicated tabs for binds and recipes.
  - Added “ModTools” class with useful methods and parameters for creating mods.
  - Added “Create mod” button in Mods GUI.
  - Added “Options” button in Mods GUI (requires the modmaker to create own GUI in <Mod Class>.tools.config_editor).
  - Added more information in the “Help” tab.
  - Added possibility to use separate preview-16.(ico|png|jpg) icon for displaying in the list of mods.
  - Added option for “Compose” that toggles visibility of alternative (related to input) recipes (now by default does not display).

- Changes:

  - “Compose” character preview in the tooltip now changes depending on the active “Glyph Variations” mode.
  - Modification’s “options.ini” replaced with “manifest.json,” base keys now stored in root instead of “[options]” section.
  - Entries “Lat. Capital/Small Letter O With Overlay Tilde” renamed to “Lat. Capital/Small Letter Barred O”, recipe changed from using middle tilde to hyphen-minus (using middle tile was mistaken).
  - Recipe of “Lat. Capital/Small Letter Open O” now uses solidus instead of hyphen-minus.
  - Search in “Panel”: matching tags now replace displayed symbol name in the first column.

- Fixes:

  - Fixed missing Space key in the “Keyboard Default” bind list.
  - Fixed mistake with applying character’s styles to the incorrect UI element of “Legends”.
  - Fixed wrong letter in recipe of “Ӛ” (Cyrillic Schwa with Diaeresis): “◌̈Ӛ/Ӛ◌̈” → “◌̈Ә/Ә◌̈”.
  - Fixed wrong description of “Glyph variations” in the “Help” tab.
  - Fixed error on startup when checking recipes with multi-reference for entries (like ${\m,u,l,t,i/}) would cause an error instead of splitting them for check each separately.
  - Fixed error with duplication of entries in the “Favorites” tab, also fixed error with removing entries from the “Favorites” tab when there are duplicates.
  - Fixed mistake with “Ħħ” recipe which used short solidus instead of short stroke.
  - Fixed wrong ordering on processing of multientries.
  - Fixed critical error with launching on Windows 11 caused by Fonts.Validation().

---

### [0.1.5.3 α — 2025-09-11](https://github.com/DemerNkardaz/DSL-KeyPad/releases/tag/0.1.5.3)

- Additions:

  - Library extended to 5,500+ Unicode characters.
  - Addded new latin characters:
    - [ ȷ ɟ ʄ ᶡ 𐞘 ]
  - Addded new miscellaneous characters:
    - [ ⸸ ⸶ ⸷ ] [ ⹀ ⹝ ⸗ ] [ ⅏ ]
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
  - Addded new cyrillic characters:
    - [ Ӫ ӫ ] [ Ӿ ӿ Ѝ ѝ Ӳ ӳ ᲅ ᲆ ᲄ ᲀ ᲂ ᲃ ᲁ ҂ ]
  - Addded new latin characters:
    - [ ᶴ ] [ Ꜩ ꜩ ] [ ꝱ ꝲ ꝳ ꝴ ꝶ ꝵ ꝷ ꝸ ] [ Ꝫ ꝫ Ꝭ ꝭ Ꝯ ꝯ ꝰ ] [ Ꝇ ꝇ ]
  - Addded new miscellaneous characters:
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

### [0.1.8.3 α — 2025-?-?](https://github.com/DemerNkardaz/DSL-KeyPad/releases/tag/0.1.8.3)

- Добавления:

  - Добавлены новые символы астрологии:
    - [ ⛎︎ ]
  - Добавлены новые символы глаголицы:
    - [ ⰯⱟⰥⱕ ]
  - Добавлены новые символы эллиницы:
    - [ ϶ ]
  - Добавлены новые прочие символы:
    - [ ⧼⧽ ⫽ ⫻ ◌⃫ ]

- Изменения:

  - Привязки для символов тона МФА перемещены с правого Alt на левый (чтобы оставить ⟨⟩ на прежней комбинации правый Alt + 9/0).
  - Удалены длинные версии рецептов для символов Алхимии, Астрологии и Астрономии (в связи с отсутствием их уместности и нарушением концепции режима «Композиции»).

- Исправления:

  - Исправлено использование некорректных скобок в подсказке TELEX/VNI-подобного режима.

---

### [0.1.7.3 α — 2025-10-04](https://github.com/DemerNkardaz/DSL-KeyPad/releases/tag/0.1.7.3)

- Добавления:

  - Библиотека расширена до 6,300+ символов Unicode.
  - Добавлены наборы символов: Инь и Ян (☯︎); монограммы, диграммы, триграммы и гексаграммы И-Цзин; монограммы, диграммы и тетраграммы Тайсюань-Цзин; Плитки/кости Мацзян; фигуры Сянци; Плитки домино.
  - Расширен набор символов шахматных фигур.
  - Добавлены сегментированные варианты цифр, контурные варианты A-Z и цифр.
  - Добавлены новые Альтернативные режимы:
    - И-Цзин и Тайсюань-Цзин.
  - Добавлены новые символы МФА:
    - [ ˥ ˦ ˧ ˨ ˩ ꜒ ꜓ ꜔ ꜕ ꜖ ꜈ ꜉ ꜊ ꜋ ꜌ ꜍ ꜎ ꜔ ꜐ ꜑ ]
  - Добавлены новые прочие символы:
    - [ ¦ ⸨⸩ ⹉ ⹍ ⹎ ⸚ ⸛ ⸞ ⸟ ⹊  ⸜⸝ ⸌⸍ ⹕⹖ ⹗⹘ ] [ 🙶🙷🙸🙻🙺🙹 ] [ 𐆠 𐆐𐆑𐆒𐆓𐆔𐆕𐆛𐆜 ]

- Изменения:

  - При поиске тегов, если запрос не содержит пробела, теперь ищет наличие целого слова в теге перед тем, как провести остальные варианты сравнения.
  - Улучшены: генерация названий/тегов для записей символов, «Поиск» и фильтрация в главном окне.
  - Режим «Композиции» теперь одновременно принимает ввод и обычных символов, и символов из суррогатных пар.
  - Вкладки главного окна теперь имеют по два элемента списков: один для отображения всех символов, второй для отображения результатов поиска по списку (теперь не требуется повторное заполнения списка при отмены поиска).
  - Теперь клавиша «Enter» в режиме «Композиции» позволяет подтвердить любой ввод. Если рецепт не был завершён — в поле ввода окажется введённая последовательность символов.

- Исправления:

  - Исправлена ошибка в Windows 11, при которой символы привязок игнорировались режимом «Композиции».
  - Исправлена ошибка режима «Композиции», когда ввод символов «()[]+» останавливал его работу.

---

### [0.1.6.3 α — 2025-09-29](https://github.com/DemerNkardaz/DSL-KeyPad/releases/tag/0.1.6.3)

- Дополнения:

  - Библиотека расширена до 5,800+ символов Unicode.
  - Набор Алхимических, Астрологических, Астрономических символов переработан и расширен.
  - Добавлены фигуры геомантии.
  - Добавлены символы шахмат, карточных мастей и игральных карт.
  - Добавлены новые символы латиницы:
    - [ 𐞥 𐞀 ⁱ ] [ ꟱ ᶧ ᵾ ᵿ ] [ ꜣ Ꜣ ꜥ Ꜥ (Египтологические Алеф и Айн) ]
  - Добавлены новые символы МФА:
    - [ 𐞁 𐞂 ]
  - Добавлены новые прочие символы:
    - [ ⸢ ⸣ ⸤ ⸥ ] [ ꜛ ꜜ ] [ ℥ ℈ ℀ ℁ ⅍ ℅ ℆ ℄ ] [ ℣ ℟ ] [ ◌͞ ◌͟ ◌͝ ]
  - Теперь символы МФА имеют собственные вкладки со списками биндов и рецептов.
  - Добавлен класс «ModTools» с полезными методами и параметрами для создания модов.
  - Добавлена кнопка «Создать мод» в GUI модификаций.
  - Добавлена кнопка «Настройки» в GUI модификаций (требует от мододела создание собственного GUI в <Mod Class>.tools.config_editor).
  - Добавлено больше информации во вкладке «Помощь».
  - Добавлена возможность использовать отдельную preview-16.(ico|png|jpg) иконку для отображения в списке модификаций.
  - Добавлена настройка режима «Композиции» для отображения альтернативных (по отношению ко вводу) рецептов совпадающих символов (теперь по умолчанию не отображает).

- Изменения:

  - Теперь превью символов в подсказке режима композиции изменяется в зависимости от активного режима Вариации глифов.
  - Для модификаций «options.ini» заменен на «manifest.json», базовые ключи теперь хранятся в корне вместо секции «[options]».
  - Записи «Лат. прописная/строчная буква О с тильдой по середине» переименованы в «Лат. прописная/строчная буква перечёркнутая О», рецепт изменён на использование дефисо-минуса вместо тильды по середине (использование тильды по середине было ошибочно).
  - Рецепт «Лат. прописная/строчная буква открытая О» теперь использует косую черту вместо дефисо-минуса.
  - Поиск в «Панели»: совпадения тегов теперь заменяют отображаемое имя символа в первой колонке.

- Исправления:

  - Исправлено отсутствие клавиши пробела в списке биндов «Keyboard Default».
  - Исправлена ошибка с присвоением стилей символа неверному элементу интерфейса «Легенды».
  - Исправлена неверная буква в рецепте «Ӛ» (Кириллическая Шва с диезерисом): «◌̈Ӛ/Ӛ◌̈» → «◌̈Ә/Ә◌̈».
  - Исправлено неверное описание режима Вриации глифов в вкладке «Помощь».
  - Исправлена ошибка при запуске: при проверке рецептов с мульти-ссылками на записи (например, ${\m,u,l,t,i/}) раньше возникала ошибка «запись не найдена» вместо разделения мульти-ссылки для проверки каждой по отдельности.
  - Исправлена ошибка с дублированием записи во вкладке «Избранное» и ошибка, возникающая при попытке убрать запись из избранного при дублировании.
  - Исправлена ошибка с рецептом символа «Ħħ», который использовал косую черту вместо штриха.
  - Исправлена неправильная последовательность при обработке мультизаписей.
  - Исправлена критичная ошибка при запуске на Windows 11, вызванная Fonts.Validation().

---

### [0.1.5.3 α — 2025-09-11](https://github.com/DemerNkardaz/DSL-KeyPad/releases/tag/0.1.5.3)

- Дополнения:

  - Библиотека расширена до 5,500+ символов Unicode.
  - Добавлены новые символы латиницы:
    - [ ȷ ɟ ʄ ᶡ 𐞘 ]
  - Добавлены новые прочие символы:
    - [ ⸸ ⸶ ⸷ ] [ ⹀ ⹝ ⸗ ] [ ⅏ ]
  - Добавлена поддержка новых раскладок латиницы:
    - Blaze, Canary (Ortho вариант), Engrammer, Focal, Pine v4, Rain, Recurva
  - Добавлена поддержка новых раскладок кириллицы:
    - Харламак, Рулемак (2018)
  - Добавлены новые Альтернативные режимы:
    - Имперское арамейское, Манихейское, Самаритянское письмо
  - Добавлены новые Вариации глифов:
    - Региональные индикаторы, в круге, двойном круге, закрашенном круге, скобках, квадрате, закрашенном квадрате, с точкой и с запятой, теги
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
  - Добавлены новые символы кириллицы:
    - [ Ӫ ӫ ] [ Ӿ ӿ Ѝ ѝ Ӳ ӳ ᲅ ᲆ ᲄ ᲀ ᲂ ᲃ ᲁ ҂ ]
  - Добавлены новые символы латиницы:
    - [ ᶴ ] [ Ꜩ ꜩ ] [ ꝱ ꝲ ꝳ ꝴ ꝶ ꝵ ꝷ ꝸ ] [ Ꝫ ꝫ Ꝭ ꝭ Ꝯ ꝯ ꝰ ] [ Ꝇ ꝇ ]
  - Добавлены новые прочие символы:
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
