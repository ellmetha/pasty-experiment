/* eslint-env browser */

import Noty from 'noty';


/**
 * Basic object allowing to initialize the appropriate behaviour allowing to get flash messages
 * displayed in a nice way to the final users.
 */
export default {
  init() {
    const flashMessages = document.querySelectorAll('#flash_messages .message');
    for (let i = 0; i < flashMessages.length; i += 1) {
      const message = flashMessages[i];
      new Noty({
        text: message.dataset.msg,
        type: message.dataset.type === 'alert' ? 'alert' : 'success',
        timeout: 3000,
        theme: 'sunset',
        layout: 'bottomRight',
      }).show();
    }
  },
};
