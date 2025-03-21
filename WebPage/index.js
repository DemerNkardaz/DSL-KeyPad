document.addEventListener('DOMContentLoaded', () => {
	console.log('Page loaded and DOM is ready.');

	document.body.addEventListener('click', (event) => {
		const target = event.target;

		if (target.classList.contains('clickable')) {
			console.log('Clickable element clicked:', target);
			handleElementClick(target);
		}
	});
});

function handleElementClick(element) {
	console.log('Handling click for element:', element);
}