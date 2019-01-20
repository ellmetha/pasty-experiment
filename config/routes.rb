Rails.application.routes.draw do
  devise_for :users,
             path: 'users',
             path_names: {
               sign_in: 'signin',
               sign_out: 'signout',
               sign_up: 'signup'
             },
             sign_out_via: 'get'
  mount Sidekiq::Web => '/sidekiq'
  resources :snippets, only: %i[show create], path: ''
  root 'snippets#new'
end
