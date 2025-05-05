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
	document.querySelector('.content-footer').innerHTML = getCopyrightString();

	// Вставка <p> элемента с Unicode диапазоном
	const descriptionElement = document.querySelector('.alternative-mode-description');
	if (descriptionElement) {
		const unicodeContent = getUnicodeRange("0300-034E", " ", "\u25CC");
		const paragraph = document.createElement('p');
		paragraph.textContent = unicodeContent;
		descriptionElement.appendChild(paragraph);
	}


	document.querySelectorAll('details').forEach((el) => {
		if (!el.open) {
			el.classList.add('closed');
		}
		new Accordion(el);
	});

});

function handleElementClick(element) {
	console.log('Handling click for element:', element);
}



// Пример использования:
console.log(getUnicodeCharacters('1F600')); // Вывод: 😀
console.log(getUnicodeCharacters('1F600', '1F601', '1F602')); // Вывод: 😀😁😂
console.log(getUnicodeCharacters(0x1F600, 0x1F601)); // Вывод: 😀😁 (поддержка чисел сохраняется)

// Пример использования:
console.log(getUnicodeRange("1E000-1E006;1E008-1E018;1E01B-1E021;1E023-1E024;1E026-1E02A", "", "\u25CC")); 
console.log(getUnicodeRange("2C00-2C5F"));
console.log(getUnicodeRange("2C00-2C05", ", "));