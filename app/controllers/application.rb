# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'e4c29cd2c8542a9fb84715bfb5648e74'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  def rescue_action_in_public(exception)
    case exception
      when ActiveRecord::RecordNotFound, ActionController::RoutingError, ActionController::UnknownController, ActionController::UnknownAction
        render_404
      else          
        render_500
    end
  end
  def load_themes
    @themes = {
    				"all_hallows_eve" => "All Hallow's Eve",
    				"blackboard" => "Blackboard",
    				"brilliance_black" => "Brilliance Black",
    				"cobalt" => "Cobalt",
    				"expreso_libre" => "Espresso Libre",
    				"idle" => "IDLE",
    				"mac_classic" => "Mac Classic",
    				"magicwb_amiga" => "MagicWB (Amiga)",
    				"pastels_on_dark" => "Pastels on Dark",
    				"slate" => "Slate",
    				"slush_and_poppies" => "Slush and Poppies",
    				"sunburst" => "Sunburst",
    				"sunburst_josh" => "Sunburst (Josh)",
    				"twilight" => "Twilight",
    				"vibrant_ink" => "Vibrant Ink"

    			}
  			@theme = (params[:theme] if @themes.include?(params[:theme])) || "idle"

  end
  def load_languages
    unless read_fragment({})
       @languages = Language.find :all, :order => "name"       
    end
  end
  
  
end
