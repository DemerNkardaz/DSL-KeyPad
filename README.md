# DSL KeyPad \*in dev

## On English

This tool provides simplified access to various “special characters” such as spaces, diacritical marks, ligatures, special symbols (⁂‡‰250⁄250, etc.) via hotkeys or other auxiliary tools.

The main panel of the program can be opened using the combination **Win Alt Home**, it lists all existing combinations and commands, including:

- Inserting a character by Unicode/Alt-code or its “tag”.
- Converting numbers to Roman Numerals (17489 → ↂↁⅯⅯⅭⅭⅭⅭⅬⅩⅩⅩⅨ) or to superscript/subscript numbers.
- The “Smelter” of characters **Win Alt L**: it allows you to create a specific symbol/ligature by combining available keyboard symbols, for example: ІУЖ → Ѭ, ІА → Ꙗ, AV → Ꜹ, AE◌́ → Ǽ, gbp → £. If the resource does not support combining characters (á = 2 symbols, a◌́, and may turn out to be as “a ́  ”), then some letters can be melted into one mark (á = 1 symbol).
  - Melt selected symbols: **RShift L**.
  - Melt symbols on left of caret cursor: **RShift Backspace**.
  - “Compose” Mode **RAlt×2**: inserts the result of the input sequence as soon as an exact match with one of the “recipes” is detected during input.

Most combinations are divided into “activation groups” and you need to first activate the desired group, for example, “Win Alt F1” for “First Diacritic Group,” and then press the key for the desired mark, for example, “a” for acute \[á\].

You can activate “Quick Keys” via RAlt Home, the simplified combinations for a limited set of characters, such as “Ctrl Alt a” for entering the same acute mark; strict on the Russian keyboard: “RAlt е” for entering “ѣ”, “RAlt и” for entering the Cyrillic “і”, “RAlt э” for entering “є”, etc.

For using the “DSL KeyPad” you need to simply [download the .ahk file](https://github.com/DemerNkardaz/DSL-KeyPad/blob/main/Install.KeyPad.ahk) and run it in the directory where you want to have the main file of this tool. In the program also there is the system of updates and you do not need to go to the repository again for getting the latest version.

## На русском

Эта утилита позволяет вводить широкий спектр различных символов без надобности использования «карт символов» или других источников для копирования. Она включает в себя диакритические знаки (◌́◌̋◌̆◌̑◌̀◌̏◌̄◌̱), разновидности пробелов/шпаций ( <ins> </ins>, <ins> </ins>, <ins> </ins>, <ins> </ins>, <ins> </ins> ) и тире/дефисов (⸻, ⸺, —, –, ‐), кавычки («Русские „Кавычки“», “English ‘Quotation Marks’”, „«Ghilimele» Românești”,「東アジアの『引用符』」), пунктуацию (…, ¡, ¿, ⁉, ⁈, ‼, ⁇, ‽, ⸘), лигатуры (ꜲÆꜶꜸꜴꜼƢꝠꙖꙒ), буквы (ĂÂǍɃḈðɆǶÞǷꝹѪѦЄҴ), валюты (₽¥₩€£₸₪) и специальные символы (§′″°∞≠≈×−±⁑⁂†‡‰‱←↓↑→↺↻⮌⮏⮍⮎250⁄250), обычно недоступные на клавиатуре. С полным перечнем символов можно ознакомиться в *Панели*, открывающуюся комбинацией **Win Alt Home** или в пунктах меню в трее.

## Методы ввода

- **Группы** — базовый метод, включающий диакритические знаки, пробелы, тире/дефисы, кавычки и специальные символы. Необходимо активировать группу символов, а затем нажать на кнопку нужного знака, например: **Win Alt F1** активирует «Основную группу диакритики», после чего можно нажать на «ф(a)» для ввода акута [á] или «ь(m)» для ввода макрона [m̄]. Всего групп восемь: Диакритика (F1, F2, F3, F6), Специальные символы (F7), Шпации (Пробел), Тире (-) и Кавычки (").
- **Быстрые ключи** — использует **LCtrl LAlt**, **LAlt** или **RAlt** в качестве «начальных» клавиш комбинаций для ускоренного ввода избранных символов. Включает в себя больше символов, чем «группы».

  Диакритические знаки в основном располагаются в комбинациях с **LCtrl LAlt**. Ввод, например, тех же акута и макрона, осуществляется комбинациями **LCtrl LAlt a** и **LCtrl LAlt m**.

  Комбинации с **RAlt** в основном служат для ввода букв и специальных символов: **RAlt E** на английском раскладке введёт «Ĕ», а на русской «Ѫ». Комбинация **RAlt A**: «Ă» или «Ѳ» соответственно. Имеется и небольшое количество «простых комбинаций» — **NumpadSub** вместо дефисо‐минуса (-) будет вводить знак минуса (−), а комбинация **NumpadAdd NumpadSub** введёт плюс-минус (±).

  **Примечание:** по умолчанию функция отключена, и её можно активировать комбинацией **RAlt Home**.

- **«Плавильня»** — конвертирует последовательность знаков («рецепт») в другой знак, что позволяет получать лигатуры («AE» → «Æ», «ІѪ» → «Ѭ»), акцентные буквы («Ă» *два символа* → «Ă» _единый символ_) или просто буквы («ПС» → «Ѱ», «КС» → «Ѯ», «ДЖ» → «Џ») и прочие символы («+−» → «±», «\*\*\*» → «⁂», «YEN» → «¥», «°C» *два символа* → «℃» _единый символ_).

  Плавильня включает в себя четыре способа её использовать:

  - Через всплывающее окно, **Win Alt L**.
  - В тексте через выделение рецепта, **RShift L**.
  - В тексте, установив курсор каретки после рецепта, **RShift Backspace**.
  - Режиме «Compose» — даёт возможность использовать «сплавку» знаков прямо при вводе, **RAlt×2**. Сразу вставляет в поле ввода первое точное совпадение с вводимой последовательностью. Есть возможность включить/отключить ожидание через **PauseBreak** (так как ряд рецептов начинаются одинакого), и «Compose» не будет сразу вставлять первое совпадение.

## Вспомогательные функции

- Вставка символа по ID Юникода или по Alt‐коду, **Win Alt U**/**A**.
- Вставка символа по внутреннему тегу в утилите, **Win Alt F**.
- Конвертация числа в Римские Цифры («17489» → «ↂↁⅯⅯⅭⅭⅭⅭⅬⅩⅩⅩⅨ») или в надстрочные/подстрочные цифры, **Win RAlt 3**/**1**/**2**.
- Изменение ввода «Символ → HTML‐код/Мнемоника → LaTeX → Символ», **RAlt RShift Home**. Если переключить ввод с «Символ» на «HTML», тогда будет вводиться соответствующий код, например: вместо кавычек «» будет введено _\&laquo;\&raquo;_, или вместо Ѫ → *\&#1130;*.

  **Примечание:** LaTeX коды доступны не для всех символов, а некоторые коды указаны из подключаемых пакетов (которые указываются над кодом LaTeX в Панели).

- Обработчики текста:

  - «Кавычкизация» — обрамляет выделенный текст кавычками (в зависимости от активной раскладки): Гай Тиберий, Палач Галлов → «Гай Тиберий, Палач Галлов», или Гай Тиберий, «Палач Галлов» → «Гай Тиберий, „Палач Галлов“».
  - «GREP»‐Замены — заменяет обычные пробелы в выделенном тексте его разновидностями, например неразрывным пробелом после одно‐/двубуквенных слов (а, в, не) и некоторых трёхбуквенных (для), в цифрах (1 000, 10 000, 100 000…); узким пробелом в инициалах (И. О. Фамилия); и т.д.

    **Примечание:** основано на типографике для русского языка.

  - Отбивка отступа абзаца — добавляет в начало абзацев выделенного текста Круглую шпацию для «симуляции красной строки». Больше необходимо для тех мест, где технически нельзя создать абзацный отступ иным «цивилизованным» образом. Так же в абзацах, начинающихся с длинного тире (диалоговые абзацы) заменяет пробел после данного тире на полукруглую шпацию.

## Ограничения

Утилита может быть использована _(стабильно)_ только на Английской или Русскоязычной раскладках (включая и [«Типографскую раскладку»](https://ilyabirman.ru/typography-layout/)), так как основывается именно на их клавишах для комбинаций. Использование комбинаций «Быстрых ключей» за пределами этих раскладок игнорируется, однако «Группы» остаются доступными.

## Установка

Для использования «DSL KeyPad» требуется просто [скачать .ahk файл](https://github.com/DemerNkardaz/DSL-KeyPad/blob/main/Install.KeyPad.ahk) и запустить. Основной файл утилиты будет скачан туда же, где вы запустите «установщик», остальные файлы попадут в «Мои Документы\DSLKeyPad».

---

![](Images/20240905_0.png)

![](Images/20240905_1.png)

![](Images/20240910_0.png)

![](Images/20240910_1.png)

![](Images/20240910_2.png)

# License

All own code source (i.e. exclude third-party code parts) is licensed under the [MIT License](https://github.com/DemerNkardaz/DSL-KeyPad/blob/main/LICENSE)
