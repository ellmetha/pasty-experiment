import hljs from 'highlight.js';


export default {
  init() {
    // Initializes Highlight JS.
    const blocks = document.querySelectorAll('pre code');
    for (let i = 0; i < blocks.length; i += 1) {
      hljs.highlightBlock(blocks[i]);
    }
  },
};
