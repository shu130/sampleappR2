Rails.application.routes.draw do

  root to: "tops#home"

  get    'tops/home'
  get    'tops/help'
  get    'tops/about'
  get    'tops/contact'


end
