Rails.application.routes.draw do

  root to: "tops#home"

  get    'home',    to: 'tops#home'
  get    'help',    to: 'tops#help'
  get    'about',   to: 'tops#about'
  get    'contact', to: 'tops#contact'

  get    'signup',  to: 'users#new'

  get    'login',   to: 'sessions#new'
  post   'login',   to: 'sessions#create'
  delete 'logout',  to: 'sessions#destroy'

  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :microposts,          only: [:create, :destroy]
end
