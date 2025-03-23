/**
 * @param {...(number|string)} codePoints - Неопределённое число кодовых позиций (число или строка).
 * Возвращает символ(ы) по кодовой позиции Unicode.
 * @returns {string} Символ или строка символов.
 */
function getUnicodeCharacters(...codePoints) {
	const toCodePoint = code => 
		typeof code === 'string' ? parseInt(code, 16) : code;

	return codePoints.map(code => String.fromCodePoint(toCodePoint(code))).join('');
}


/**
 * Возвращает строку со всеми символами Unicode из указанного диапазона или множества диапазонов.
 * @param {string} ranges - Диапазон(ы) в формате "XXXX-YYYY;ZZZZ-WWWW" (где XXXX, YYYY и т.д. — шестнадцатеричные кодовые позиции).
 * @param {string} [separator=""] - Разделитель между символами (по умолчанию — пустая строка).
 * @param {string} [prefix=""] - Символ, добавляемый перед каждым вставляемым символом (по умолчанию — пусто).
 * @returns {string} Строка символов из указанного диапазона(ов).
 */
function getUnicodeRange(ranges, separator = "", prefix = "") {
	const characters = [];

	ranges.split(';').forEach(range => {
		const [start, end] = range.split('-').map(code => parseInt(code, 16));
		if (isNaN(start) || isNaN(end) || start > end) {
			throw new Error(`Некорректный диапазон Unicode: ${range}`);
		}

		for (let codePoint = start; codePoint <= end; codePoint++) {
			characters.push(prefix + String.fromCodePoint(codePoint));
		}
	});

	return characters.join(separator);
}

/**
 * Возвращает строку копирайта от 2024 года до текущего года.
 * @returns {string} Строка копирайта, например, "© 2024-2025".
 */
function getCopyrightString() {
	const startYear = 2024;
	const currentYear = new Date().getFullYear();
	return language === 'en' ? `&COPY;&emsp14;${startYear}${currentYear > startYear ? `-${currentYear}` : ''}&emsp14;Yalla Nkardaz` : `&COPY;&emsp14;Я&#769;лла&nbsp;Нкарда&#769;з,&emsp14;${startYear}${currentYear > startYear ? `–${currentYear}` : ''}`;
}

// Пример использования:
console.log(getCopyrightString()); // Вывод: "© 2024-2025" (если текущий год 2025)



