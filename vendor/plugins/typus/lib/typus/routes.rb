class ActionController::Routing::RouteSet

  alias draw_without_admin draw

  def draw_with_admin

    draw_without_admin do |map|

      map.with_options :controller => 'typus' do |i|
        i.typus_dashboard "admin", :action => 'dashboard'
        i.typus_login "admin/login", :action => 'login'
        i.typus_logout "admin/logout", :action => 'logout'
        i.typus_email_password "admin/email_password", :action => 'email_password'
        i.typus_index "admin/:model", :action => 'index'
        i.connect "admin/:model/:action", :requirements => { :action => /index|new|create/ }
        i.connect "admin/:model/:id/:action", :requirements => { :action => /edit|update|destroy|position|toggle|relate|unrelate/, :id => /\d+/ }
      end

      map.connect "admin/:model/:action", :controller => "typus/#{:model}"
      map.connect "admin/:model/:id/:action", :controller => "typus/#{:model}"

      yield map

    end

  end

  alias draw draw_with_admin

end