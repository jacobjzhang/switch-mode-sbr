require 'resque/server'

Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    get 'users/:id' => 'users#show'

    resources :resumes

    get 'search', to: :search, controller: 'jobs'
  end

  mount Resque::Server, at: '/resque'

  mount_ember_app :frontend, to: "/"
end
