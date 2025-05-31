[![GitHub](https://custom-icon-badges.herokuapp.com/badge/GitHub-[Main]-eeeeee?logoColor=eeeeee&style=for-the-badge&logo=github&labelColor=363B40)](https://github.com/DemerNkardaz/DSL-KeyPad) [![GitLab](https://custom-icon-badges.herokuapp.com/badge/Git-Lab-db4128?logoColor=db4128&style=for-the-badge&logo=gitlab&labelColor=363B40)](https://gitlab.com/DemerNkardaz/dsl-keypad) [![SourceForge](https://custom-icon-badges.herokuapp.com/badge/Source-Forge-f76300?logoColor=f76300&style=for-the-badge&logo=sourceforge&labelColor=363B40)](https://sourceforge.net/projects/dsl-keypad/) [![Bitbucket](https://custom-icon-badges.herokuapp.com/badge/Bit-Bucket-eee?logoColor=eee&style=for-the-badge&logo=bitbucket&labelColor=2d79ce)](https://bitbucket.org/nkardaz/public/src/)

<br>

# <span title="Diacritics-Spaces-Letters KeyPad">${\color{#e2b041}\mathbf{DSL \ KeyPad}}$</span>

![unicode](https://custom-icon-badges.herokuapp.com/badge/unicode_symbols-4200+-yellow?logo=unicode&labelColor=ffffff) ![forge](https://custom-icon-badges.herokuapp.com/badge/forge’s_sequences-3400+-yellow?logoColor=333333&logo=anvil&labelColor=ffffff) ![binds](https://custom-icon-badges.herokuapp.com/badge/binds-1800+/600+-yellow?logo=keybind&labelColor=ffffff) <br> ![wakatime](https://wakatime.com/badge/user/e572f348-6192-4188-a508-7efe46e45cd5/project/687cb256-bc63-49cf-b4c8-fc242ad60efb.svg?style=social) ![](https://img.shields.io/github/watchers/DemerNkardaz/DSL-KeyPad) ![](https://img.shields.io/github/stars/DemerNkardaz/DSL-KeyPad) ![](https://img.shields.io/gitlab/stars/DemerNkardaz%2Fdsl-keypad) ![Badge](https://hitscounter.dev/api/hit?url=https%3A%2F%2Fgithub.com%2FDemerNkardaz%2FDSL-KeyPad&label=visits&color=yellow)

<img src="src/Bin/DSLKeyPad_App_Icons/DSLKeyPad.app.ico" alt="" width="128" align="left">

“DSL KeyPad” is a tool written on [AutoHotkey 2.0](https://www.autohotkey.com/), designed for inputting a wide range of characters using hotkeys, [Compose](https://en.wikipedia.org/wiki/Compose_key)-like mode and auxiliary functions. Its primary focus is on enhancing input capabilities for Latin and Cyrillic scripts, allowing typing in multiple languages without the need for separate keyboard layouts for each language.

You can check the docs for this tool [here](https://demernkardaz.github.io/DSL-KeyPad/). Downloading available on [Releases](https://github.com/DemerNkardaz/DSL-KeyPad/releases) & [SourceForge](https://sourceforge.net/projects/dsl-keypad/files/).

<br>

![Sequences Tab](webpage/media/panel_forge_tab.png)

<p align="center">
	<i>Forge’s Sequences Tab</i>
</p>

<br>

### Shortlist of Features

- **Multilayer Hotkeys**: Including different for English (“Latin set”) and Russian (“Cyrillic set”).  
  E.g., \[en.\] <kbd>RAlt + A or Z</kbd> → `Ă`/`Ż`, then \[ru.\] <kbd>RAlt + Ф or Я</kbd> → `Ѳ`/`Ѧ`. Supports user-defined key bindings.

- **Compositing Mode, or “Forge”**: Converts a sequence (“recipes”) of one set of characters into another.  
  E.g., `AE` `OE` `TH` `ІѦ` `ЯЕ` `ⰦⰤ` `Ups` → `Æ` `Œ` `Þ` `Ѩ` `Ԙ` `Ⱙ` `Ʊ`. Supports user-defined recipes.

- **Alternative Input**: A set of modes for various non-Latin/Cyrillic scripts (primarily historic), IPA, and mathematical symbols.  
  E.g., \[Runic `ᛢᚹᛖᚱᛏᚤᚢᛁᛟᛈᚨᛊᛞᚠᚷᚺᛃᚲᛚᛉᚳᚡᛒᚾᛗ᛬`\] \[Glagolitic `ⰉⰜⰖⰍⰅⰐⰃⰞⰛⰈⰘⰟⰗⰂⰀⰒⰓⰡⰝⰔⰏⰋⰠⰁⰣⰦ`\].

- **Glyph Variations**: Allows entering alternative variants of symbols, if available.  
  E.g., `A` → `ᴬ` `𝐴` `𝐀` `𝑨` `𝙰` `Ａ` `ᴀ` `𝔄` `𝕬` `𝒜` `𝓐` `𝔸`.

- **Switch Between Entering Unicode Symbols/HTML Code/ $\LaTeX$ Codes**, if available.  
  E.g., `Ă` `Ǣ` → `&Abreve;` `&#482;` ${\color{darkorange}\texttt{and}}$ `\u{A}` `\={\AE}` ${\color{darkorange}\texttt{or}}$ `\breve{A}` `\bar{\AE}` $\breve{A}$ $\text{Ǣ}$.

- **Search Symbols in Local Library by Tags**: Allows searching for symbols in the local library by tags for easy input.  
  E.g., `latin small ligature turned oe with short stroke` or shortened `oe tur str` → `ꭂ`.

- **Internal Keyboard Layouts**: Includes support for user-defined layouts.

- **Other Features...**

### Examples of languages/systems that can be typed:

- **Latin**: <span title="Old English">Ænglisċ</span>, <span title="French">Français</span>, <span title="Romanian">Română</span>, <span title="Vietnamese">Tiếng Việt</span>, <span title="Mandarin (Romanization)">Hànyǔ Pīnyīn</span>, <span title="Polish">Język polski</span>, <span title="Czech">Čeština</span>, <span title="Norwegian Bokmål">Bokmål</span>, <span title="Turkish">Türkçe</span>, <span title="Old Norse">Norrœnt Mál</span>.
- **Cyrillic**: <span title="Old Church Slavonic">Словѣньскъ ѩꙁꙑкъ</span>, <span title="Kazakh">Қазақ тілі</span>, <span title="Romanian (Cyrillic)">Лимба Рѹмѫнѣскъ</span>, <span title="Ukrainian">Українська мова</span>, <span title="Abkhaz">Аԥсуа Бызшәа</span>, <span title="Tajik">Забони тоҷикӣ</span>.

<br>

**⚠️ AutoHotkey is required to use this tool.** Install it via Powershell or [download from its site](https://www.autohotkey.com/).

```powershell
winget install AutoHotkey.AutoHotkey
```

<br>

<p align="center">
	<table>
		<tr>
			<td><img src="webpage/media/panel_fastkeys_tab.png" alt="FastKeys Tab" width="460"></td>
			<td><img src="webpage/media/panel_scripts_tab.png" alt="Scripts Tab" width="460"></td>
		</tr>
		<tr>
			<th><i>FastKeys Tab</i></th>
			<th><i>Scripts Tab</i></th>
		</tr>
		<tr>
			<td><img src="webpage/media/panel_commands_tab.png" alt="Commands Tab" width="460"></td>
			<td><img src="webpage/media/panel_about_tab.png" alt="About Tab" width="460"></td>
		</tr>
		<tr>
			<th><i>Commands Tab</i></th>
			<th><i>About Tab</i></th>
		</tr>
		<tr>
			<td><img src="webpage/media/scripter_alternative_input.png" alt="Alternative Input Selector" width="460"></td>
			<td><img src="webpage/media/scripter_glyph_variatioins.png" alt="Glyph Variations Selector" width="460"></td>
		</tr>
		<tr>
			<th><i>Alternative Input Selector</i></th>
			<th><i>Glyph Variations Selector</i></th>
		</tr>
		<tr>
			<td><img src="webpage/media/user_recipes_panel.png" alt="User Recipes Panel" width="460"></td>
			<td><img src="webpage/media/user_recipes_editor.png" alt="User Recipes Editor" width="460"></td>
		</tr>
		<tr>
			<th><i>User-Defined Recipes Panel</i></th>
			<th><i>User-Defined Recipes Editor</i></th>
		</tr>
	</table>
<p>

<br>

**Strong** recommendation: use the extended character set only for text writing, no more.<br>Using these characters for passwords, file names, etc., is dangerous.

**Strong 2** recommendation: turn off all AutoHotkey processes while playing games with sensitive anti-cheat systems. Games do not tolerate people who use AHK for gaining an advantage, and it is possible to be kicked or banned for having an AHK process running, even if the script does not provide an advantage.

---

### \[ На Русском \]

«DSL KeyPad» — утилита на языке [AutoHotkey 2.0](https://www.autohotkey.com/) для ввода широкого спектра символов посредством горячих клавиш, [Compose](https://en.wikipedia.org/wiki/Compose_key)-подобного режима и вспомогательных функций. Основное направление — расширение возможностей для ввода латиницы и кириллицы, что позволяет писать на множестве языков без использования отдельных раскладок для каждого из языков.

Вы можете ознакомиться с документацией утилиты [здесь](https://demernkardaz.github.io/DSL-KeyPad/). Скачивание доступно в [Релизах](https://github.com/DemerNkardaz/DSL-KeyPad/releases) и на [SourceForge](https://sourceforge.net/projects/dsl-keypad/files/).

### Краткий список возможностей

- **Многослойные горячие клавиши**: в том числе — разные для английского («латинский набор») и русского («кириллический набор»).<br>Например, \[en.\] <kbd>RAlt + A или Z</kbd> → `Ă`/`Ż`, затем \[ru.\] <kbd>RAlt + Ф или Я</kbd> → `Ѳ`/`Ѧ`. Поддерживаются пользовательские привязки клавиш.

- **Режим композиции, или «Кузница»**: преобразует последовательность («рецепты») одного набора символов в другой.<br>Например, `AE` `OE` `TH` `ІѦ` `ЯЕ` `ⰦⰤ` `Ups` → `Æ` `Œ` `Þ` `Ѩ` `Ԙ` `Ⱙ` `Ʊ`. Поддерживаются пользовательские рецепты.

- **Альтернативный ввод**: набор режимов для различных нелатинских/некириллических форм письменности (в основном исторических), IPA и математических символов.<br>Например, \[Руны `ᛢᚹᛖᚱᛏᚤᚢᛁᛟᛈᚨᛊᛞᚠᚷᚺᛃᚲᛚᛉᚳᚡᛒᚾᛗ᛬`\] \[Глаголица `ⰉⰜⰖⰍⰅⰐⰃⰞⰛⰈⰘⰟⰗⰂⰀⰒⰓⰡⰝⰔⰏⰋⰠⰁⰣⰦ`\].

- **Вариации глифов**: Позволяет вводить альтернативные варианты символов, если они доступны.<br>Например, `A` → `ᴬ` `𝐴` `𝐀` `𝑨` `𝙰` `Ａ` `ᴀ` `𝔄` `𝕬` `𝒜` `𝓐` `𝔸`.

- **Переключение между вводом Unicode-символов/HTML-кодов/ $\LaTeX$-кодов**, если доступно.<br>Например, `Ă` `Ǣ` → `&Abreve;` `&#482;` ${\color{darkorange}\texttt{и}}$ `\u{A}` `\={\AE}` ${\color{darkorange}\texttt{или}}$ `\breve{A}` `\bar{\AE}` $\breve{A}$ $\text{Ǣ}$.

- **Поиск символов в локальной библиотеке по тегам**: позволяет искать символы в локальной библиотеке по тегам для ввода.<br>Например, `latin small ligature turned oe with short stroke` или сокращённо `oe tur str` → `ꭂ`.

- **Внутренние раскладки клавиатуры**: включает поддержку пользовательских раскладок.

- **Другие возможности…**

### Примеры языков/систем, которые могут быть введены:

- **Латиница**: <span title="Древнеанглийский">Ænglisċ</span>, <span title="Французский">Français</span>, <span title="Румынский">Română</span>, <span title="Вьетнамский">Tiếng Việt</span>, <span title="Мандаринский (романизация)">Hànyǔ Pīnyīn</span>, <span title="Польский">Język polski</span>, <span title="Чешский">Čeština</span>, <span title="Норвежский Букмол">Bokmål</span>, <span title="Турецкий">Türkçe</span>, <span title="Древнескандинавский">Norrœnt Mál</span>.
- **Кириллица**: <span title="Старославянский">Словѣньскъ ѩꙁꙑкъ</span>, <span title="Румынский (Валахо-молдавская кириллица)">Лимба Рѹмѫнѣскъ</span>, <span title="Казахский">Қазақ тілі</span>, <span title="Украинский">Українська мова</span>, <span title="Абхазский">Аԥсуа Бызшәа</span>, <span title="Таджикский">Забони тоҷикӣ</span>.

<br>

**⚠️ Для работы требуется AutoHotkey.** Установите его через Powershell или [скачайте с официального сайта](https://www.autohotkey.com/).

```powershell
winget install AutoHotkey.AutoHotkey
```

<br>

**Сильная** рекомендация: используйте расширенный набор символов только для написания текста, не более.<br>Использование этих символов для паролей, имен файлов и т. д. небезопасно.

**Сильная 2** рекомендация: отключайте все процессы AutoHotkey во время игр с чувствительными античит-системами. Некоторые игры не очень толерантны к людям, использующим AHK для получения нечестного преимущества, и это может привести к кику или бану за наличие запущенного процесса AHK, даже если скрипт не предоставляет преимущества.

---

[![GitHub](https://img.shields.io/github/v/release/DemerNkardaz/DSL-KeyPad?include_prereleases&label=%F0%9F%8F%B7%EF%B8%8F&color=yellow)](https://github.com/DemerNkardaz/DSL-KeyPad) [![GitHub](https://img.shields.io/github/release-date-pre/DemerNkardaz/DSL-KeyPad?logo=github&color=yellow)](https://github.com/DemerNkardaz/DSL-KeyPad) ![Static Badge](https://img.shields.io/badge/AutoHotkey-V2-yellow) [![GitHub](https://img.shields.io/github/downloads-pre/DemerNkardaz/DSL-KeyPad/latest/total?logo=github&color=yellow)](https://github.com/DemerNkardaz/DSL-KeyPad)
[![jsDelivr](https://img.shields.io/jsdelivr/gh/hm/DemerNkardaz/DSL-KeyPad?logo=jsdelivr&color=yellow)](https://www.jsdelivr.com/package/gh/DemerNkardaz/DSL-KeyPad)

<details>
	<summary>Extended information</summary>

| GitHub                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | GitLab / Bitbucket                                                                                                                                                                                                                                                                                               | SourceForge                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [![GitHub](https://img.shields.io/github/downloads/DemerNkardaz/DSL-KeyPad/total?logo=github&color=yellow)](https://github.com/DemerNkardaz/DSL-KeyPad)<br>[![GitHub](https://img.shields.io/github/commit-activity/m/DemerNkardaz/DSL-KeyPad?logo=github&label=commits&color=yellow)](https://github.com/DemerNkardaz/DSL-KeyPad)<br>[![GitHub](https://img.shields.io/github/last-commit/DemerNkardaz/DSL-KeyPad/main?logo=github&color=yellow)](https://github.com/DemerNkardaz/DSL-KeyPad) | [![GitLab](https://img.shields.io/gitlab/last-commit/DemerNkardaz%2Fdsl-keypad?logo=gitlab&color=yellow)](https://gitlab.com/DemerNkardaz/dsl-keypad)<br>[![Bitbucket](https://img.shields.io/bitbucket/last-commit/nkardaz/public/main?logo=bitbucket&color=yellow)](https://bitbucket.org/nkardaz/public/src/) | [![SourceForge](https://img.shields.io/sourceforge/dm/dsl-keypad?logo=sourceforge&color=yellow)](https://sourceforge.net/projects/dsl-keypad/)<br>[![SourceForge](https://img.shields.io/sourceforge/commit-count/dsl-keypad/code?logo=sourceforge&label=commits&color=yellow)](https://sourceforge.net/projects/dsl-keypad/)<br>[![SourceForge](https://img.shields.io/sourceforge/last-commit/dsl-keypad/code?logo=sourceforge&color=yellow)](https://sourceforge.net/projects/dsl-keypad/) |

</details>
