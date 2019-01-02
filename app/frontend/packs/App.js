import '@babel/polyfill';

// Imports global app stylesheet.
import 'styles/App.scss';

// Ensures all images are imported.
const importAll = (r) => r.keys().map(r)
importAll(require.context('../images', false, /\.(png|jpe?g|svg)$/));
