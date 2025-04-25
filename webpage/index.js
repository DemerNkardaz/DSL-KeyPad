const SUPPORTED_LANGUAGES = ['en', 'ru'];
const userLanguage = navigator.language.slice(0, 2).toLowerCase();
const language = SUPPORTED_LANGUAGES.includes(userLanguage) ? userLanguage : 'en';