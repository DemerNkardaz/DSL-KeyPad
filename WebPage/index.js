const SUPPORTED_LANGUAGES = ['en', 'ru'];
const userLanguage = navigator.language.slice(0, 2).toLowerCase();
const language = SUPPORTED_LANGUAGES.includes(userLanguage) ? userLanguage : 'en';


document.addEventListener('DOMContentLoaded', () => {
	console.log('Page loaded and DOM is ready.');

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