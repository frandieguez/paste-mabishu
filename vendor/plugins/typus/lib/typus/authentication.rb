module Authentication

  protected

    ##
    # Before doing nothing on Typus require_login
    #
    def require_login
      redirect_to typus_login_url unless session[:typus]
    end

    ##
    # Check if the user is logged on the system.
    #
    def logged_in?
      return false unless session[:typus]
      @current_user ||= TypusUser.find(session[:typus])
    rescue ActiveRecord::RecordNotFound
      session[:typus] = nil
    end

    ##
    # Return the current user
    #
    def current_user
      @current_user if logged_in?
    end

    ##
    #
    #
    def generate_password(length=8)
      chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
      password = ""
      1.upto(length) { |i| password << chars[rand(chars.size - 1)] }
      return password
    end

end