const fs = require('fs');
const https = require('https');

const url = 'https://html.spec.whatwg.org/entities.json';

const saveToFile = (data, filename) => {
	fs.writeFileSync(filename, data, 'utf8');
	console.log(`Данные записаны в файл: ${filename}`);
};

https.get(url, (response) => {
	let data = '';

	response.on('data', (chunk) => {
		data += chunk;
	});

	response.on('end', () => {
		const entities = JSON.parse(data);
		const resultMap = new Map();

		for (const entity in entities) {
			if (!entity.endsWith(';')) {
				continue;
			}
			const char = entities[entity].characters;
			const unicodeHex = char.codePointAt(0).toString(16).toUpperCase();
			const cleanEntity = entity.replace(/;/g, '').replace(/&/g, '');

			if (!resultMap.has(unicodeHex) || cleanEntity.length < resultMap.get(unicodeHex).length) {
				resultMap.set(unicodeHex, cleanEntity);
			}
		}

		const resultArray = [];
		for (const [unicodeHex, entity] of resultMap.entries()) {
			resultArray.push(`${unicodeHex}\t${entity}`);
		}

		const result = resultArray.join('\n');
		saveToFile(result, 'entities_list.txt');
	});
}).on('error', (err) => {
	console.error('Ошибка при загрузке данных: ' + err.message);
});
