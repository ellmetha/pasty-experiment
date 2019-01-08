import hljs from 'highlight.js';


export default {
  init() {
    const block = document.querySelector('pre code');
    hljs.highlightBlock(block);
  },
};
