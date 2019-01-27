import RegistrationEditController from './registration/EditController';
import SnippetShowController from './snippet/ShowController';
import SnippetUserListController from './snippet/UserListController';

// Defines the controllers object.
export default {
  'snippet:show': SnippetShowController,
  'snippet:user_list': SnippetUserListController,
  'registration:edit': RegistrationEditController,
};
