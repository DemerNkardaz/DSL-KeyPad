## Version 0.1.1 — 2024-10-10

- Implementation of the first version of the “DSL KeyPad” utility, including:
  - Creation of the initial symbol library and an interface for interacting with it.
  - Basic groups of combinations for diacritics and special symbols.
  - A “Quick Keys” feature for faster access to a set of symbols.
  - Functions for inserting symbols by “tag”/Unicode/Alt-code.
  - Functions to convert numbers to uppercase/lowercase or Roman numerals.
  - A function to convert input between “Symbol → HTML-code → LaTeX → Symbol” (if the symbol in the library supports it).
  - A “Forge” function that allows users to generate multiple symbols using keyboard-accessible combinations. Includes a “Compose” mode for direct input of combinations without dialog windows or selection.
  - Text processing functions that partially format selected text‑replacing spaces with non‑breaking spaces or varieties of spaces where “necessary”; applying indentation to paragraphs with a round space or wrapping selection in quotes.
  - Addition of a “super-layout” for writing in Germanic/Anglo‑Saxon runes and Glagolitic.
    - Includes support for Combining Glagolitic input.
  - Addition of a “super-layout” for Old Turkic and Olrd Permic scripts.
  - Addition of a “super-layout” for Gothic Alphabet.
  - Implementation of the “Dvorak” and “Colemak” layouts for the Latin Script.
  - Implementation of the “ЙІУКЕН (1970)” and “Diktor” layouts for the Cyrillic Script.
  - A system for updates and change logs.
