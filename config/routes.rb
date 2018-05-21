Rails.application.routes.draw do

  get 'user/new'

  root to: "tops#home"

  get    'home',    to: 'tops#home'
  get    'help',    to: 'tops#help'
  get    'about',   to: 'tops#about'
  get    'contact', to: 'tops#contact'

end
