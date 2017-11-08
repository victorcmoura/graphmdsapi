Rails.application.routes.draw do
  resources :associations
  resources :repositories
  resources :users

  get '/', to: 'application#index'
  get '/get_repositories_from_github', to: 'repositories#get_from_github'
  get '/get_users_from_github', to: 'users#get_from_github'
  get '/get_repositories_from_users', to: 'users#get_repositories_from_users'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
