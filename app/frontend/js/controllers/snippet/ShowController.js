import Clipboard from 'clipboard';
import hljs from 'highlight.js';


export default {
  init() {
    // Initializes Highlight JS.
    const block = document.querySelector('pre code');
    hljs.highlightBlock(block);

    // Initializes Clipboard JS.
    new Clipboard('#copy_snippet_url_link');
  },
};
