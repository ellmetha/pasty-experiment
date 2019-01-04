Rails.application.routes.draw do
  resources :snippets, only: %i[show create], path: ''
  root 'snippets#new'
end
