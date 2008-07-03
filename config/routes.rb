ActionController::Routing::Routes.draw do |map|


  map.root :controller => "pastes", :action => "new"
  map.connect "admin", :controller => "Admin::Paginas", :action => "index"
  map.connect "search", :controller => "pastes", :action => "search"
  map.resources :paginas
  map.resources :pastes
  map.resources :languages

  map.namespace :admin, :prefix => "admin" do |admin|
    map.root :controller=> "Admin::Paginas", :action => "index"
    admin.resources :languages
    admin.resources :pastes
    admin.resources :paginas
  end

  # Install the default routes as the lowest priority.
  map.connect ':controller/:id/:action'
  map.connect ':controller/:action/:id.:format'
  map.connect "search", :controller => "pastes", :action => "search"
  map.connect ':pagina', :controller => "paginas", :action => "show"
end
