import '@babel/polyfill';

import feather from 'feather-icons/dist/feather';

import controllers from 'controllers';
import DOMRouter from 'core/DOMRouter';
import FlashMessages from 'core/flashMessages';

// Imports global app stylesheet.
// eslint-disable-next-line import/no-unresolved
import 'styles/App.scss';

// Ensures all images are imported.
const importAll = r => r.keys().map(r);
importAll(require.context('../images', false, /\.(png|jpe?g|svg)$/));


const router = new DOMRouter(controllers);

document.addEventListener('DOMContentLoaded', () => {
  // Initializes feather icons.
  feather.replace();

  // Initializes the DOM router. The DOM router is used to execute specific portions of JS code for
  // each specific page.
  router.init();

  // Initializes flash messages.
  FlashMessages.init();
});
