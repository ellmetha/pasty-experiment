Rails.application.routes.draw do
  get 'snippet/index'
  root 'snippet#index'
end
