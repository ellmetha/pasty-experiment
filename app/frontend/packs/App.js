import '@babel/polyfill';

// Imports global app stylesheet.
// eslint-disable-next-line import/no-unresolved
import 'styles/App.scss';

import controllers from 'controllers';
import DOMRouter from 'core/DOMRouter';
import FlashMessages from 'core/flashMessages';

// Ensures all images are imported.
const importAll = r => r.keys().map(r);
importAll(require.context('../images', false, /\.(png|jpe?g|svg)$/));


const router = new DOMRouter(controllers);

document.addEventListener('DOMContentLoaded', () => {
  // Initializes the DOM router. The DOM router is used to execute specific portions of JS code for
  // each specific page.
  router.init();

  // Initializes flash messages.
  FlashMessages.init();
});
