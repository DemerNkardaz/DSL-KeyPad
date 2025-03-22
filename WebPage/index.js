const SUPPORTED_LANGUAGES = ['en', 'ru'];
const userLanguage = navigator.language.slice(0, 2).toLowerCase();
const language = SUPPORTED_LANGUAGES.includes(userLanguage) ? userLanguage : 'en';


document.addEventListener('DOMContentLoaded', () => {
	console.log('Page loaded and DOM is ready.');
	document.documentElement.setAttribute('lang', language);
	

	document.body.addEventListener('click', (event) => {
		const target = event.target;

		if (target.classList.contains('clickable')) {
			console.log('Clickable element clicked:', target);
			handleElementClick(target);
		}



		if (target.classList.contains('alternative-modes-header-tab-button') || target.closest('.alternative-modes-header-tab-button')) {
			const button = target.classList.contains('alternative-modes-header-tab-button') ? target : target.closest('.alternative-modes-header-tab-button');
			const allTabButtons = document.querySelectorAll('.alternative-modes-header-tab-button');

			allTabButtons.forEach(btn => btn.classList.remove('active'));
			button.classList.add('active');
		}
	});



	
	if (document.querySelector('.alternative-modes-header-tab-button') && !document.querySelector('.alternative-modes-header-tab-button.active')) {
		document.querySelector('.alternative-modes-header-tab-button').click();
	}
});

function handleElementClick(element) {
	console.log('Handling click for element:', element);
}

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

// Пример использования:
console.log(getUnicodeCharacters('1F600')); // Вывод: 😀
console.log(getUnicodeCharacters('1F600', '1F601', '1F602')); // Вывод: 😀😁😂
console.log(getUnicodeCharacters(0x1F600, 0x1F601)); // Вывод: 😀😁 (поддержка чисел сохраняется)

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

// Пример использования:
console.log(getUnicodeRange("1E000-1E006;1E008-1E018;1E01B-1E021;1E023-1E024;1E026-1E02A", "", "\u25CC")); 
console.log(getUnicodeRange("2C00-2C5F"));
console.log(getUnicodeRange("2C00-2C05", ", "));