Rails.application.routes.draw do
  get '/503', to: 'errors#service_unavailable'
  get '/500', to: 'errors#internal_server_error'

  root 'home#index'
  resources :scrapers
end
