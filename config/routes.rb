LdapReloaded::Application.routes.draw do
  resources :accounts, :only    => :show
  resources :days, :only        => [:show, :index]
  resources :months, :only      => :index
  resources :groups, :only      => :show
  resources :memberships, :only => :show
  root :to                      => 'days#index'
end
