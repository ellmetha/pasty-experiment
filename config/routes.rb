Rails.application.routes.draw do
  resources :snippets, only: %i[show create]
  root 'snippets#new'
end
