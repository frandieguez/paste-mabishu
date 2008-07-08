ActionController::Routing::Routes.draw do |map|


  map.root :controller => "pastes", :action => "new"
  
  map.connect "admin", :controller => "Admin::Paginas", :action => "index"
  
  map.connect "search", :controller => "pastes", :action => "search"
  map.resources :paginas
  map.resources :pastes
  map.resources :languages

  map.namespace :admin, :prefix => "admin" do |admin|
    map.root :controller=> "Admin::Paginas", :action => "index"
    map.connect "admin/search", :controller => "admin/pastes", :action => "search"
    admin.resources :languages
    admin.resources :pastes
    admin.resources :paginas
  end

  map.connect ':controller/:id/:action'
  map.connect ':controller/:action/:id.:format'
  map.connect ':pagina', :controller => "paginas", :action => "show"
end
