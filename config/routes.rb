ActionController::Routing::Routes.draw do |map|
  map.resources :users,
    :only => [:new, :create],
    :has_one => [:password]

  map.resource :session,
    :only => [:new, :create, :destroy]

  map.resource :account,
    :only => [:edit, :update, :destroy]

  map.resources :passwords,
    :only => [:new, :create, :edit, :update]
end
