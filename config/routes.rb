require 'resque/server'

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  # root to: "resumes#new"
  mount_ember_app :frontend, to: "/"
  
  resources :resumes

  get 'search', to: :search, controller: 'jobs'

  mount Resque::Server, at: '/jobs'
end
