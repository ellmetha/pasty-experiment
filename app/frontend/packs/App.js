import '@babel/polyfill';

// Imports global app stylesheet.
// eslint-disable-next-line import/no-unresolved
import 'styles/App.scss';

import FlashMessages from 'js/core/flashMessages';

// Ensures all images are imported.
const importAll = r => r.keys().map(r);
importAll(require.context('../images', false, /\.(png|jpe?g|svg)$/));


document.addEventListener('DOMContentLoaded', () => {
  // Initializes flash messages.
  FlashMessages.init();
});
