ActionController::Routing::Routes.draw do |map|
  map.resource :account,
    :controller => 'evergreen/accounts',
    :only => [:edit, :update, :destroy]

  map.resources :passwords,
    :controller => 'evergreen/passwords',
    :only => [:new, :create, :edit, :update]

  map.resource :session,
    :controller => 'evergreen/sessions',
    :only => [:new, :create, :destroy]

  map.resources :users,
    :controller => 'evergreen/users',
    :only => [:new, :create],
    :has_one => [:password]
end
