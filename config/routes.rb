Rails.application.routes.draw do
  devise_for :users,
             path: 'users',
             path_names: {
               sign_in: 'signin',
               sign_out: 'signout',
               sign_up: 'signup'
             }
  resources :snippets, only: %i[show create], path: ''
  root 'snippets#new'
end
