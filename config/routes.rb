require 'resque/server'

Rails.application.routes.draw do

  # resources :users
  devise_for :users

  get 'users/:id' => 'users#show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # root to: "resumes#new"

  resources :resumes

  get 'search', to: :search, controller: 'jobs'

  mount Resque::Server, at: '/jobs'

  mount_ember_app :frontend, to: "/"
end
