# DSL KeyPad \*αλφα, version in dev

<img src="__dev/DSLKeyPad_App_Icons/DSLKeyPad.app.ico" alt="" width="128"><img src="__dev/DSLKeyPad_App_Icons/DSLKeyPad.app_norse.ico" alt="" width="100"><img src="__dev/DSLKeyPad_App_Icons/DSLKeyPad.app_glagolitic.ico" alt="" width="100"><img src="__dev/DSLKeyPad_App_Icons/DSLKeyPad.app_turkic.ico" alt="" width="100"><img src="__dev/DSLKeyPad_App_Icons/DSLKeyPad.app_permic.ico" alt="" width="100"><img src="__dev/DSLKeyPad_App_Icons/DSLKeyPad.app_hungarian.ico" alt="" width="100"><img src="__dev/DSLKeyPad_App_Icons/DSLKeyPad.app_gothic.ico" alt="" width="100"><img src="__dev/DSLKeyPad_App_Icons/DSLKeyPad.app_ipa.ico" alt="" width="100">

<img src="__dev/DSLKeyPad_App_Icons/DSLKeyPad.app_math.ico" alt="" width="62"> <img src="__dev/DSLKeyPad_App_Icons/DSLKeyPad.app_viet.ico" alt="" width="62"> <img src="__dev/DSLKeyPad_App_Icons/DSLKeyPad.app_pinyin.ico" alt="" width="62">

# Contents

- [Overview](#overview)
  - [Input Methods](#input-methods)
  - [Alternative Layouts](#alternative-layouts)
  - [Auxiliary Features](#auxiliary-features)
  - [Limitations](#limitations)
  - [Installation](#installation)
- [Обзор](#обзор)
  - [Методы ввода](#методы-ввода)
  - [Альтернативные раскладки](#альтернативные-раскладки)
  - [Вспомогательные функции](#вспомогательные-функции)
  - [Ограничения](#ограничения)
  - [Установка](#установка)

# Overview

This utility allows you to input a wide range of various symbols without the need to use “character maps” or other sources for copying. It includes diacritical marks (◌́◌̋◌̆◌̑◌̀◌̏◌̄◌̱), space/spacing variations (&#8198;<ins>&emsp;</ins> <ins>&ensp;</ins>&emsp13;<ins> </ins>&emsp14;<ins> </ins>&thinsp;<ins>&#8198;</ins>&#8198;) and dashes/hyphens (⸻, ⸺, —, –, ‐), quotation marks («Русские „Кавычки“», “English ‘Quotation Marks’”, „«Ghilimele» Românești”,「東アジアの『引用符』」), punctuation marks (…, ¡, ¿, ⁉, ⁈, ‼, ⁇, ‽, ⸘), ligatures (ꜲÆꜶꜸꜴꜼƢꝠꙖꙒ), letters (ĂÂǍɃḈðɆǶÞǷꝹѪѦЄҴ), currencies (₽¥₩€£₸₪), and special symbols (§′″°∞≠≈×−±⁑⁂†‡‰‱←↓↑→↺↻⮌⮏⮍⮎250⁄250), typically unavailable on a keyboard. You can view the full list of symbols in the *Panel*, which can be opened with <kbd>Win Alt Home</kbd>, or from the tray menu options.

Note: use it on pair QWERTY‐ЙЦУКЕН of English & Russian layouts, compatibility with another not provided.

## Input Methods

- **Groups** — the primary method, covering diacritical marks, spaces, dashes/hyphens, quotation marks, and special symbols. You need to activate a group of symbols and then press the key corresponding to the desired character. For example, <kbd>Win Alt F1</kbd> activates the "Basic Diacritics Group", after which pressing “a” will input the acute accent [á] or “m” will input a macron [m̄]. There are eight groups in total: Diacritics (<kbd>F1</kbd>, <kbd>F2</kbd>, <kbd>F3</kbd>, <kbd>F6</kbd>), Special Symbols (<kbd>F7</kbd>), Spaces (<kbd>Space</kbd>), Dashes (<kbd>-</kbd>), and Quotes (<kbd>"</kbd>).

- **Fast Keys** — uses <kbd>LCtrl LAlt</kbd>, <kbd>LAlt</kbd>, or <kbd>RAlt</kbd> as “initial” keys for quick access to chosen symbols. It includes more symbols than the “Groups”.

  Diacritical marks are mostly accessed through <kbd>LCtrl LAlt</kbd> combinations. For example, the same acute accent and macron can be entered using <kbd>LCtrl LAlt a</kbd> and <kbd>LCtrl LAlt m</kbd>, respectively.

  <kbd>RAlt</kbd> combinations are primarily used for letters and special symbols. For example, <kbd>RAlt E</kbd> on an English layout will type “Ĕ”, and on a Russian layout “Ѫ”. The combination <kbd>RAlt A</kbd> types “Ă” or “Ѳ” depending on the layout. Additionally, there are a few "simple combinations" — <kbd>NumpadSub</kbd> will insert the minus sign (−) instead of the hyphen-minus (-), and <kbd>NumpadAdd NumpadSub</kbd> will insert the plus-minus symbol (±).

  **Note:** This function is disabled by default and can be enabled with **RAlt Home**.

- **“Forge”** — converts a sequence of characters (“recipe”) into another character, allowing the creation of ligatures (“AE” → “Æ”, “ІѪ” → “Ѭ”), accented letters (“Ă” *two characters* → “Ă” _one character_), or even letters (“ПС” → “Ѱ”, “КС” → “Ѯ”, “ДЖ” → “Џ”) and other symbols (“+−” → “±”, “\*\*\*” → “⁂”, “YEN” → “¥”, “°C” *two characters* → “℃” _one character_).

  The Forge has four ways to use it:

  - Through the pop-up window, <kbd>Win Alt L</kbd>.
  - In text via recipe selection, <kbd>RShift L</kbd>.
  - In text, by placing the caret cursor after the recipe, <kbd>RShift Backspace</kbd>.
  - In “Compose” mode — allows you to "fuse" characters during typing, <kbd>RAlt×2</kbd>. It immediately inserts the first exact match for the entered sequence. There is an option to enable/disable waiting with <kbd>PauseBreak</kbd> (as some recipes start the same way), so “Compose” will not immediately insert the first match.

## Alternative Layouts

<kbd>RCtrl 1</kbd> switches input from Russian/English to Glagolitic/Germanic‐Norse, Anglo‐Saxon runes. Pressing <kbd>А</kbd><kbd>Б</kbd> or <kbd>RAlt Ф</kbd>, for example, will input Ⰰ, Ⰱ, or Ⱚ, while pressing <kbd>A</kbd>, <kbd>W</kbd>, <kbd>F</kbd> will input ᚨ, ᚹ, ᚠ.

<kbd>RCtrl 2</kbd> similarly activates the input of Old Turkic and Old Permic scripts, “𐱃𐰞𐰤𐰪𐰅𐰺” “<img src="Images/old_permic.png" alt="Old Permic" width="60">”. Old Permic requires the [Noto Sans Old Permic](https://fonts.google.com/noto/specimen/Noto+Sans+Old+Permic) font.

<kbd>RCtrl 4</kbd> activates the input of Gothic script, “𐌱𐌴𐍂𐌺𐌰𐌹𐌽𐌰 𐍉𐌸𐌰𐌻𐌰 𐍅𐌿𐌽𐌾𐌰 𐍄𐍅𐌶”.

## Auxiliary Features

- Insert a character by Unicode ID or Alt-code, <kbd>Win Alt <kbd>U</kbd>/<kbd>A</kbd></kbd>.
- Insert a character by its internal tag in the utility, <kbd>Win Alt F</kbd>.
- Convert numbers into Roman Numerals (“17489” → “ↂↁⅯⅯⅭⅭⅭⅭⅬⅩⅩⅩⅨ”) or superscript/subscript digits, <kbd>Win RAlt <kbd>3</kbd>/<kbd>1</kbd>/<kbd>2</kbd></kbd>.
- Switch between input methods (Character → HTML Code/Mnemonic → LaTeX → Character), <kbd>RAlt RShift Home</kbd>. If you switch input from "Character" to "HTML", the corresponding code will be entered, for example, instead of quotes “”, _\&ldquo;\&rdquo;_ will be entered, or instead of Æ → *\&AElig;*.

  **Note:** LaTeX codes are not available for all characters, and some codes are from external packages (which are listed above the LaTeX code in the Panel).

- Text Processors:

  - “Quotationizing” — wraps selected text in quotation marks (depending on the active layout): Gaius Tiberius, Executioner of the Gauls → “Gaius Tiberius, Executioner of the Gauls”, or Gaius Tiberius, “Executioner of the Gauls” → “Gaius Tiberius, ‘Executioner of the Gauls’”.

  - “GREP”-Replacements — replaces regular spaces in the selected text with their variants, for example, non-breaking spaces after one/two-letter words (а, в, не) and some three-letter words (для), or in numbers (1 000, 10 000, 100 000...); thin spaces in initials (I. O. Surname); and so on.

    **Note:** Based on typography rules for Russian.

  - Paragraph indentation — adds an Em-space at the beginning of paragraphs to simulate first-line indentation. This is especially useful for places where you cannot create paragraph indentation in a “civilized” way. Additionally, in paragraphs starting with an em-dash (russian dialogue paragraphs), it replaces the space after the dash with a en-space.

## Limitations

The utility can be used _(reliably)_ only on English or Russian layouts (including [the “Typography Layout”](https://ilyabirman.net/typography-layout/)), as it is based specifically on their keys for combinations. The use of “Fast Key” combinations outside these layouts is ignored, but “Groups” remain available.

## Installation

To use “DSL KeyPad”, simply [download the .ahk file](https://github.com/DemerNkardaz/DSL-KeyPad/blob/main/Install.KeyPad.ahk), run it and choose where utility will be installed.

# Обзор

«DSL KeyPad» — утилита на языке [AutoHotkey 2.0](https://www.autohotkey.com/) для ввода спектра символов юникода посредством горячих клавиш и вспомогательных функций. Основное направление — расширение возможностей для ввода латиницы и кириллицы, а в будущем возможно расширение и на греческие символы.

<img src="__dev/DSLKeyPad_App_Icons/DSLKeyPad.app_latin.ico" alt="" width="62" align="right">

### Латиница

Утилита поддерживает ввод большинства символов латиницы, включая их вариации (комбинируемые, надстрочные, подстрочные, математические). Имея лишь базовую US раскладку возможно письмо на множестве языков/систем (включая исторических) на основе латиницы, например:

- [Limba Românească](https://ru.wikipedia.org/wiki/Румынский_язык): Țara, Învăța, Șase.
- [Gagauzça](https://ru.wikipedia.org/wiki/Гагаузский_язык): Sölzlük, Harţaklı, Sürçmää.
- [Ænglisċ](https://ru.wikipedia.org/wiki/Древнеанглийский_язык): Ƿeorðmyndum, Æġhƿylc, Þeod.
- [Norrœnt Mál](https://ru.wikipedia.org/wiki/Древнескандинавский_язык): Þrúðvangar, Mjǫðr, Kvæði.
- [Norsk](https://ru.wikipedia.org/wiki/Норвежский_язык): Høvåg, Ærlig, Skatteøya.
- [Deutsch](https://ru.wikipedia.org/wiki/Немецкий_язык): Straße, Österreich, Süß.
- [Français](https://ru.wikipedia.org/wiki/Французский_язык): Déjà, Sœur, Laïque.
- [Malti](https://ru.wikipedia.org/wiki/Мальтийский_язык): Għaqda, Iżda, Oċean.
- [Español](https://ru.wikipedia.org/wiki/Испанский_язык): ¿Cuántos años…, Éxito, Corazón.
- [Język polski](https://ru.wikipedia.org/wiki/Польский_язык): Wiedźmin, Żołnierz, Natknąć się.
- [Čeština](https://ru.wikipedia.org/wiki/Чешский_язык): Zřetelně, Výpůjčka, Vyvíjí.
- [Latviešu valoda](https://ru.wikipedia.org/wiki/Латышский_язык): Katoļu ticību, Luterāņu katķisma.
- [<img src="__dev/DSLKeyPad_App_Icons/DSLKeyPad.app_viet.ico" alt="" width="32" align="left"> Tiếng Việt](https://ru.wikipedia.org/wiki/Вьетнамский_язык): Thương Ưởng, Đế Chế, Rồng phương Bắc.<br>&emsp;Для облегчения письма присутствует Vietnamese TELEX/VNI‐подобный режим ввода: <kbd>RAlt F2</kbd>
- [<img src="__dev/DSLKeyPad_App_Icons/DSLKeyPad.app_pinyin.ico" alt="" width="32" align="left"> Hànyǔ Pīnyīn「汉语拼音」](https://ru.wikipedia.org/wiki/Пиньинь): Māo「貓」, Gǔ「谷」, Gōngtíng「宮廷」.<br>&emsp;Аналогично присутствует Vietnamese TELEX/VNI‐подобный режим ввода: <kbd>RAlt RShift F2</kbd>

[Здесь](https://github.com/DemerNkardaz/DSL-KeyPad/wiki/Languages-Input〈Fast-Keys-%25-Compose〉) представлен перечень таблиц‐подсказок для многоязычного ввода.

<img src="__dev/DSLKeyPad_App_Icons/DSLKeyPad.app_cyrillic.ico" alt="" width="62" align="right">

### Кириллица

Поддерживается и множество кириллических символов, требующих наличие обычной русскоязычной раскладки. Как и в случае с латиницей, возможно письмо на ряде языков (включая исторических) с кириллическим алфавитом, например:

- [Словѣньскъ ѩзꙑкъ](https://ru.wikipedia.org/wiki/Старославянский_язык): Благоѫханиѥ, Бєꙁѹмьникъ, Єѵрѡпа.
- [Лимба Рѹмѫнѣскъ](https://ru.wikipedia.org/wiki/Старорумынский_язык): Ꙟвъца.
- [Беларуская мова](https://ru.wikipedia.org/wiki/Белорусский_язык): Драўніна, Ўніверсітэт.
- [Українська мова](https://ru.wikipedia.org/wiki/Украинский_язык): Поїзд, Білий, Євангеліє.
- [Црногорски језик](https://ru.wikipedia.org/wiki/Черногорский_язык): Ђетић, Ђевојка, Коштањ.
- [Македонски јазик](https://ru.wikipedia.org/wiki/Македонский_язык): Џоконда, Луѓе, Одењето.
- [Қазақ тілі](https://ru.wikipedia.org/wiki/Казахский_язык): Мәліметтер, Ыңғай, Көз.
- [Забони тоҷикӣ](https://ru.wikipedia.org/wiki/Таджикский_язык): Дӯстон, Баҳри.

<img src="__dev/DSLKeyPad_App_Icons/DSLKeyPad.app_greek.ico" alt="" width="62" align="right">

### Греческий

На данный момент отдельной поддержки для греческого языка и языков на основе греческого письма нет. Однако имеются мысли о её вводе в будущем.<br><br>

---

<img src="__dev/DSLKeyPad_App_Icons/DSLKeyPad.app_punctuation.ico" alt="" width="62" align="right">

### Пунктуация

Дополнительно ко вводу букв, поддерживается и ввод множества символов для пунктуации на различных языках, например:

| Символы                | Пример                                                                                                                                                          |
| ---------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ! ‼ ⁉ ¡ ? ⁇ ¿ ⸮ ⁈ ‽ ⸘  | ¿En qué dirección están las montañas? <br> ¡Madre mía, esto es un descubrimiento increíble!                                                                     |
| … ⁚ ⁝ ⁞ ·              | Диапазон чисел: −15…17,3 ℃                                                                                                                                      |
| ‐ ‑ — – ⸻ ⸺ ‒ ‧        | Диапазон чисел: 15–17,3 ℃ <br> — Ёримаса, стой! — воскликнул Тадахиса. <br> “Yorimasa, stop!” — Tadahisa exclaimed.                                             |
| «» ‹› “” ‘’ „” „“ „⹂ ‚ | Организация «НВК „Рассвет“» отправила экспедицию. <br> The “SMC ‘Dawn’” organization sent an expedition. <br> Organizația „CȘM «Răsărit»” a trimis o expediție. |

<img src="__dev/DSLKeyPad_App_Icons/DSLKeyPad.app_diacritics.ico" alt="" width="62" align="right">

### Комбинируемая диакритика

Одна из первых категорий символов, добавленных в утилиту. Включает множество «основных» диакритических знаков, комбинируемых с другими символами и используется в ряде функций утилиты для получения акцентных букв, например, в режиме «Compose»: <kbd>RAlt×2</kbd>, `A` + ◌̆ + ◌́ = `Ắ`.

<img src="Images/diacritics.png" alt="" width="600">

<br>

<img src="__graphics/DSLKeyPad.app_space256.png" alt="" width="128" align="right">

### Шпации

Вторая из добавленных в утилиту категория символов. Включает почти все разновидности пробелов:

| Название                          | Ширина пробела              |
| --------------------------------- | --------------------------- |
| Неразрывный пробел                | <ins>&nbsp;</ins>           |
| Круглая шпация                    | <ins>&emsp;</ins>           |
| Полукруглая шпация                | <ins>&ensp;</ins>           |
| Цифровой пробел                   | <ins>&numsp;</ins>          |
| 1⁄3 круглой шпации                | <ins>&emsp13;</ins>         |
| 1⁄4 круглой шпации                | <ins>&emsp14;</ins>         |
| 1⁄6 круглой шпации                | <ins>&#8198;</ins>          |
| Узкий пробел                      | <ins>&thinsp;</ins>         |
| Узкий неразрывный пробел          | <ins>&#8239;</ins>          |
| Волосяная шпация                  | <ins>&hairsp;</ins>         |
| Пунктуационный пробел             | <ins>&puncsp;</ins>         |
| Пробел нулевой ширины             | <ins>&ZeroWidthSpace;</ins> |
| Неразрывный пробел нулевой ширины | <ins>&#65279;</ins>         |
| Em‑Квадрат                        | <ins>&#8193;</ins>          |
| En‑Квадрат                        | <ins>&#8192;</ins>          |
| Соединитель слов                  | <ins>&NoBreak;</ins>        |

_Соединитель слов_ не является разновидностью пробела, но был добавлен вместе со шпациями в составе «одной группы».

<img src="__dev/DSLKeyPad_App_Icons/DSLKeyPad.app_special.ico" alt="" width="62" align="right">

### …и различные прочие символы

Включён и ряд других разных символов, как знаки валют, типографские, математические знаки, стрелки и так далее, например:

| Символ                                                                                                                                                      |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ←↑↓→↖↗↙↘↔↕↺↻⮌⮍⮏⮎ <br> ※ ⁑ ⁂ ⁎ † ‡ ⹋ § © 🄯 ℗ ™ ℠ ′ ″ ‴ ⁗ ° <br> ‰ ‱ ÷ × ⋇ − ± ∓ ≈ ∽ ≋ ∑ ⨋ ∏ ∪ ∫ ∬ ∰ ∆ ∇ ≤ ≧ <br> ₽ ₹ ₱ ₴ ¢ ₣ £ ₤ ₺ € ₳ ₶ ₩ ¥ 円 元 ₫ ₮ ₸ ₪ ₿ |

---

## Альтернативные режимы ввода

Режимы, которые активируются «поверх» английской и/или русской раскладок и представляют собой, в основном, различные виды письменностей.

<img src="__dev/DSLKeyPad_App_Icons/DSLKeyPad.app_norse.ico" alt="" width="62" align="right">

### [Руническое письмо](https://ru.wikipedia.org/wiki/Руны)

Активация: <kbd>RCtrl 1</kbd><br>\[Английская раскладка\]

Включает практически все германские/англо‐саксонские рунические символы:

| Старший Футарк                                       | Футорк                                | Младший Футарк                                      | Средневековые | «Золотые числа» |
| ---------------------------------------------------- | ------------------------------------- | --------------------------------------------------- | ------------- | --------------- |
| ᚨ ᛒ ᛞ ᛖ ᚠ ᚷ ᚺ ᛁ ᛇ ᛃ ᚲ ᛚ ᛗ <br> ᚾ ᛜ ᛟ ᛈ ᚱ ᛊ ᛏ ᚦ ᚢ ᚹ ᛉ | …ᚪ ᚫ ᚳ ᛠ ᚸ ᚻ ᛄ ᛡ ᛤ ᛣ <br> ᛝ ᚩ ᛢ ᛋ ᛥ ᚣ | …ᛅ ᛆ ᛓ ᚼ ᚽ ᚴ ᛘ ᛙ ᚿ ᚬ ᚭ ᛌ <br> ᛐ ᚤ ᛦ ᛧ ᛨ ᛂ ᚧ ᛑ ᛛ ᛔ ᚡ | …ᛍ ᛀ ᚰ ᚮ ᛪ ᛎ  | …ᛮ ᛯ ᛰ          |

<img src="__dev/DSLKeyPad_App_Icons/DSLKeyPad.app_glagolitic.ico" alt="" width="62" align="right">

### [Глаголица](https://ru.wikipedia.org/wiki/Глаголица)

Активация: <kbd>RCtrl 1</kbd><br>\[Русская раскладка\]

Старославянская письменность; Включает как обычные символы, так и комбинируемые.

| Символы (не все)                                                                               |
| ---------------------------------------------------------------------------------------------- |
| Ⰰ Ⰱ Ⰲ Ⰳ Ⰴ Ⰵ Ⰶ Ⰷ Ⰸ Ⰹ Ⰺ Ⰻ Ⰼ Ⰽ Ⰾ Ⰿ Ⱀ Ⱁ Ⱂ Ⱃ Ⱄ Ⱅ Ⱛ Ⱆ Ⱇ Ⱈ Ⱉ Ⱊ Ⱌ Ⱍ Ⱎ Ⱋ Ⱏ (ⰟⰊ) Ⱐ Ⱑ Ⱖ Ⱒ Ⱓ Ⱔ Ⱗ Ⱘ Ⱙ Ⱚ Ⱜ Ⱝ |

<img src="__dev/DSLKeyPad_App_Icons/DSLKeyPad.app_turkic.ico" alt="" width="62" align="right">

### [Древнетюркское письмо](https://ru.wikipedia.org/wiki/Древнетюркское_письмо)

Активация: <kbd>RCtrl 2</kbd><br>\[Английская раскладка\] \[Письмо справа налево\]

_Орхоно‐енисейкое письмо_

| Орхонский репертуар                                                                      | Енисейский репертуар                                            |
| ---------------------------------------------------------------------------------------- | --------------------------------------------------------------- |
| 𐰀 𐰃 𐰆 𐰇 𐰲 𐰢 𐰭 𐰯 𐱁 𐰔 𐰡 𐰨 𐰪 𐰦 𐱈 𐰉 𐰋 𐰑 𐰓 𐰞 𐰠 𐰣 𐰤 𐰺 <br> 𐰼 𐰽 𐰾 𐱃 𐱅 𐰖 𐰘 𐰍 𐰏 𐰴 𐰚 𐰸 𐰜 𐰶 𐰱 𐰿 𐰰 𐱇 | …𐰁 𐰂 𐰅 𐰄 𐰈 𐰳 𐱂 𐰕 𐰩 𐰫 𐰧 𐰊 𐰌 𐰒 𐰟 𐰥 𐰻 𐱄 𐱆 𐰗 𐰙 𐰎 <br> 𐰐 𐰵 𐰛 𐰹 𐰝 𐰷 𐱀 |

<img src="__dev/DSLKeyPad_App_Icons/DSLKeyPad.app_permic.ico" alt="" width="62" align="right">

### [Древнепермское письмо](https://ru.wikipedia.org/wiki/Древнепермское_письмо)

Активация: <kbd>RCtrl 2</kbd><br>\[Русская раскладка\] \[Требует шрифт [Noto Sans Old Permic](https://fonts.google.com/noto/specimen/Noto+Sans+Old+Permic)\]

Старая письменность для языков коми.

| Символы (не все)                                                         |
| ------------------------------------------------------------------------ |
| <img src="Images/old_permic_full.png" alt="" width="700" align="center"> |

<img src="__dev/DSLKeyPad_App_Icons/DSLKeyPad.app_hungarian.ico" alt="" width="62" align="right">

### [Секейское руническое письмо](https://ru.wikipedia.org/wiki/Секельское_руническое_письмо)

Активация: <kbd>RCtrl 3</kbd><br>\[Английская раскладка\] \[Письмо справа налево\] \[Требует шрифт [Noto Sans Old Hungarian](https://fonts.google.com/noto/specimen/Noto+Sans+Old+Hungarian)\]

Иначе — _«Венгерские руны»_

| Символы                                                                     |
| --------------------------------------------------------------------------- |
| <img src="Images/old_hungarian_full.png" alt="" width="700" align="center"> |

<img src="__dev/DSLKeyPad_App_Icons/DSLKeyPad.app_gothic.ico" alt="" width="62" align="right">

### [Готское письмо](https://ru.wikipedia.org/wiki/Готское_письмо)

Активация: <kbd>RCtrl 4</kbd><br>\[Английская раскладка\]

| Символы                                               |
| ----------------------------------------------------- |
| 𐌰 𐌱 𐌲 𐌳 𐌴 𐌵 𐌶 𐌷 𐌸 𐌹 𐌺 𐌻 𐌼 𐌽 𐌾 𐌿 𐍀 𐍁 𐍂 𐍃 𐍄 𐍅 𐍆 𐍇 𐍈 𐍉 𐍊 |

<br>

<img src="__dev/DSLKeyPad_App_Icons/DSLKeyPad.app_ipa.ico" alt="" width="62" align="right">
<img src="__dev/DSLKeyPad_App_Icons/DSLKeyPad.app_math.ico" alt="" width="62" align="right">

### Математический режим и МФА

Активация: <kbd>RCtrl 9</kbd> / <kbd>RCtrl 0</kbd><br>\[Английская раскладка\]

Математический режим упрощает доступ ко множеству математических символов через клавиши A–Z, в то время как второй режим упрощает ввод символов Международного фонетического алфавита.

_Оба режима не завершены_

---

## Важные функции

### «Плавильня»

Набор методов‐обработчиков, позволяющих конвертировать последовательность одних символов в другие. Через «плавильню» реализуется вариативность методов ввода. Ряд символов, например, как «Æ», «Œ», «Ꜹ», «Ѭ», «Ѩ» и т.д. возможно напечатать только через функции «плавильни». Базово доступен в виде диалогового окна через <kbd>LWin LAlt L</kbd>.

Список доступных последовательностей можно посмотреть на «Панели» во вкладке «Плавильня».

#### «Compose»

Активация: <kbd>RAlt×2</kbd>

Дополнительный способ использования плавильни, позволяющий вводить последовательность символов не отвлекаясь от текстового поля. По мере ввода у курсора каретки или курсора мыши будет отображён список возможных комбинаций и их результата; рецепты символов из _списка избранного_ всегда будут отображены в подсказке.

Вставка символа сработает сразу как произойдёт точное совпадение ввода и любого из рецептов. Попытка ввести «sumint» для получения «⨋» закончится получением символа «∑» сразу после ввода «sum», однако активный режим можно поставить на паузу клавишей <kbd>PauseBreak</kbd> и тогда для срабатывания он будет ожидать снятия с паузы или нажатия клавиши <kbd>Enter</kbd>. Отменить режим можно с помощью клавиши <kbd>Esc</kbd> или вводом несуществующей последовательности.

С активной паузой в начало запроса можно добавить «(\~) », и тогда «Compose» сможет обрабатывать последовательность внутри слов. Например, попытка ввести «Ōthalą» (O◌̄thala◌̨) приведёт к ошибке поиска рецепта, но в случае «(\~) Ōthalą» найденные в слове последовательности будут обработаны: «Ōþalą».

<img src="Images/compose_suggestions_ru.png" alt="" width="430">

#### «Мои Рецепты»

Плавильня поддерживает возможность создания собственных последовательностей через соответствующее окно интерфейса. Возможно создание рецептов с многострочным и/или объёмным результатом, но использовать через чур много текста не рекомендуется. В результатах можно использовать табуляцию. «Мои рецепты» так же будут отображаться в предложениях режима «Compose».

Для одной записи можно назначить сразу несколько последовательностей, разделяя их «|». Так, например, если установить последовательности как «змк|csl» и результат «🏯», то и «змк» и «csl» приведут к вставке эмодзи замка.

**Дополнительно:** утилита автоматически читает любые [«\*.XCompose»](https://wiki.debian.org/XCompose) файлы в поддиректории «\User\» и создает рецепты из них. Однако это работает только в отношении простых символьных последовательностей. «Мёртвые клавиши» и подобное не поддерживается.

<img src="Images/myrecipes_ru.png" alt="" width="1024">

---

Старое:

Эта утилита позволяет вводить широкий спектр различных символов без надобности использования «карт символов» или других источников для копирования. Она включает в себя диакритические знаки (◌́◌̋◌̆◌̑◌̀◌̏◌̄◌̱), разновидности пробелов/шпаций (&#8198;<ins>&emsp;</ins> <ins>&ensp;</ins>&emsp13;<ins> </ins>&emsp14;<ins> </ins>&thinsp;<ins>&#8198;</ins>&#8198;) и тире/дефисов (⸻, ⸺, —, –, ‐), кавычки («Русские „Кавычки“», “English ‘Quotation Marks’”, „«Ghilimele» Românești”,「東アジアの『引用符』」), пунктуацию (…, ¡, ¿, ⁉, ⁈, ‼, ⁇, ‽, ⸘), лигатуры (ꜲÆꜶꜸꜴꜼƢꝠꙖꙒ), буквы (ĂÂǍɃḈðɆǶÞǷꝹѪѦЄҴ), валюты (₽¥₩€£₸₪) и специальные символы (§′″°∞≠≈×−±⁑⁂†‡‰‱←↓↑→↺↻⮌⮏⮍⮎250⁄250), обычно недоступные на клавиатуре. С полным перечнем символов можно ознакомиться в *Панели*, открывающуюся комбинацией <kbd>Win Alt Home</kbd> или в пунктах меню в трее.

Примечание: используйте только в паре QWERTY‐ЙЦУКЕН английской и русской раскладок, совместимость с другим не предусмотрена.

## Методы ввода

- **Группы** — базовый метод, включающий диакритические знаки, пробелы, тире/дефисы, кавычки и специальные символы. Необходимо активировать группу символов, а затем нажать на кнопку нужного знака, например: <kbd>Win Alt F1</kbd> активирует «Основную группу диакритики», после чего можно нажать на «ф(a)» для ввода акута [á] или «ь(m)» для ввода макрона [m̄]. Всего групп восемь: Диакритика (F1, F2, F3, F6), Специальные символы (F7), Шпации (Пробел), Тире (-) и Кавычки (").
- **Быстрые ключи** — использует <kbd>LCtrl LAlt</kbd>, <kbd>LAlt</kbd> или <kbd>RAlt</kbd> в качестве «начальных» клавиш комбинаций для ускоренного ввода избранных символов. Включает в себя больше символов, чем «группы».

  Диакритические знаки в основном располагаются в комбинациях с <kbd>LCtrl LAlt</kbd> Ввод, например, тех же акута и макрона, осуществляется комбинациями<kbd>LCtrl LAlt a</kbd> и <kbd>LCtrl LAlt m</kbd>

  Комбинации с <kbd>RAlt</kbd> в основном служат для ввода букв и специальных символов: <kbd>RAlt E</kbd> на английском раскладке введёт «Ĕ», а на русской «Ѫ». Комбинация <kbd>RAlt A</kbd> «Ă» или «Ѳ» соответственно. Имеется и небольшое количество «простых комбинаций» — <kbd>NumpadSub</kbd> вместо дефисо‐минуса (-) будет вводить знак минуса (−), а комбинация <kbd>NumpadAdd NumpadSub</kbd> введёт плюс-минус (±).

  **Примечание:** по умолчанию функция отключена, и её можно активировать комбинацией <kbd>RAlt Home</kbd>.

- **«Плавильня»** — конвертирует последовательность знаков («рецепт») в другой знак, что позволяет получать лигатуры («AE» → «Æ», «ІѪ» → «Ѭ»), акцентные буквы («Ă» *два символа* → «Ă» _единый символ_) или просто буквы («ПС» → «Ѱ», «КС» → «Ѯ», «ДЖ» → «Џ») и прочие символы («+−» → «±», «\*\*\*» → «⁂», «YEN» → «¥», «°C» *два символа* → «℃» _единый символ_).

  Плавильня включает в себя четыре способа её использовать:

  - Через всплывающее окно, <kbd>Win Alt L</kbd>.
  - В тексте через выделение рецепта, <kbd>RShift L</kbd>.
  - В тексте, установив курсор каретки после рецепта, <kbd>RShift Backspace</kbd>.
  - Режиме «Compose» — даёт возможность использовать «сплавку» знаков прямо при вводе, <kbd>RAlt×2</kbd>. Сразу вставляет в поле ввода первое точное совпадение с вводимой последовательностью. Есть возможность включить/отключить ожидание через <kbd>PauseBreak</kbd> (так как ряд рецептов начинаются одинакого), и «Compose» не будет сразу вставлять первое совпадение.

## Альтернативные раскладки

<kbd>RCtrl 1</kbd> активирует переключение ввода с Русского/Английского на ввод Глаголицы/Германо‐скандинавских, Англосаксонских Рун. Нажатие <kbd>А</kbd><kbd>Б</kbd> или <kbd>RAlt Ф</kbd>, например, введёт Ⰰ, Ⰱ или Ⱚ, а нажатие <kbd>A</kbd>,<kbd>W</kbd>,<kbd>F</kbd> введёт ᚨ, ᚹ, ᚠ.

<kbd>RCtrl 2</kbd> аналогично активирует ввод Древнетюркского и Древнепермского письма, «𐱃𐰞𐰤𐰪𐰅𐰺» «<img src="Images/old_permic.png" alt="Old Permic" width="60">». Древнепермский требует шрифт [Noto Sans Old Permic](https://fonts.google.com/noto/specimen/Noto+Sans+Old+Permic).

<kbd>RCtrl 4</kbd> активирует ввод Готского письма, «𐌱𐌴𐍂𐌺𐌰𐌹𐌽𐌰 𐍉𐌸𐌰𐌻𐌰 𐍅𐌿𐌽𐌾𐌰 𐍄𐍅𐌶».

## Вспомогательные функции

- Вставка символа по ID Юникода или по Alt‐коду, <kbd>Win Alt <kbd>U</kbd>/<kbd>A</kbd></kbd>.
- Вставка символа по внутреннему тегу в утилите, <kbd>Win Alt F</kbd>.
- Конвертация числа в Римские Цифры («17489» → «ↂↁⅯⅯⅭⅭⅭⅭⅬⅩⅩⅩⅨ») или в надстрочные/подстрочные цифры, <kbd>Win RAlt <kbd>3</kbd>/<kbd>1</kbd>/<kbd>2</kbd></kbd>.
- Изменение ввода «Символ → HTML‐код/Мнемоника → LaTeX → Символ», <kbd>RAlt RShift Home</kbd>. Если переключить ввод с «Символ» на «HTML», тогда будет вводиться соответствующий код, например: вместо кавычек «» будет введено _\&laquo;\&raquo;_, или вместо Ѫ → *\&#1130;*.

  **Примечание:** LaTeX коды доступны не для всех символов, а некоторые коды указаны из подключаемых пакетов (которые указываются над кодом LaTeX в Панели).

- Обработчики текста:

  - «Кавычкизация» — обрамляет выделенный текст кавычками (в зависимости от активной раскладки): Гай Тиберий, Палач Галлов → «Гай Тиберий, Палач Галлов», или Гай Тиберий, «Палач Галлов» → «Гай Тиберий, „Палач Галлов“».
  - «GREP»‐Замены — заменяет обычные пробелы в выделенном тексте его разновидностями, например неразрывным пробелом после одно‐/двубуквенных слов (а, в, не) и некоторых трёхбуквенных (для), в цифрах (1 000, 10 000, 100 000…); узким пробелом в инициалах (И. О. Фамилия); и т.д.

    **Примечание:** основано на типографике для русского языка.

  - Отбивка отступа абзаца — добавляет в начало абзацев выделенного текста Круглую шпацию для «симуляции красной строки». Больше необходимо для тех мест, где технически нельзя создать абзацный отступ иным «цивилизованным» образом. Так же в абзацах, начинающихся с длинного тире (диалоговые абзацы) заменяет пробел после данного тире на полукруглую шпацию.

## Ограничения

Утилита может быть использована _(стабильно)_ только на Английской или Русскоязычной раскладках (включая и [«Типографскую раскладку»](https://ilyabirman.ru/typography-layout/)), так как основывается именно на их клавишах для комбинаций. Использование комбинаций «Быстрых ключей» за пределами этих раскладок игнорируется, однако «Группы» остаются доступными.

## Установка

Для использования «DSL KeyPad» требуется просто [скачать .ahk файл](https://github.com/DemerNkardaz/DSL-KeyPad/blob/main/Install.KeyPad.ahk), запустить и выбрать директорию, где будет расположена папка утилиты.

---

![](Images/20240905_0.png)

![](Images/20240905_1.png)

![](Images/20240910_0.png)

![](Images/20240910_1.png)

![](Images/20240910_2.png)

# License

All own code source (i.e. exclude third-party code parts) is licensed under the [MIT License](https://github.com/DemerNkardaz/DSL-KeyPad/blob/main/LICENSE)
