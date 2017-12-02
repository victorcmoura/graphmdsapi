Rails.application.routes.draw do
  resources :association_with_users
  resources :associations
  resources :repositories
  resources :users

  get '/', to: 'application#index'
  get '/get_repositories_from_github', to: 'repositories#get_from_github'
  get '/get_users_from_github', to: 'users#get_from_github'
  get '/get_repositories_from_users', to: 'users#get_repositories_from_users'
  get '/make_associations_between_users', to: 'association_with_users#create_associations_from_database'
  post '/shortest_path', to: 'association_with_users#shortest_path_between_two_users'
  post '/dijkstra', to: 'association_with_users#dijkstra'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
