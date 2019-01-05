Rails.application.routes.draw do
  devise_for :users
  resources :snippets, only: %i[show create], path: ''
  root 'snippets#new'
end
