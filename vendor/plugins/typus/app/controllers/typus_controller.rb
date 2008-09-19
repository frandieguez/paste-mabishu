class TypusController < ApplicationController

  filter_parameter_logging :password

  include Authentication

  before_filter :require_login, :except => [ :login, :logout, :email_password ]
  before_filter :current_user, :except => [ :login, :logout, :email_password ]

  before_filter :set_previous_action, :except => [ :dashboard, :login, :logout, :create, :email_password ]
  before_filter :set_model, :except => [ :dashboard, :login, :logout, :email_password ]

  before_filter :find_model, :only => [ :show, :edit, :update, :destroy, :toggle, :position ]

  before_filter :check_permissions, :only => [ :index, :new, :create, :edit, :update, :destroy, :toggle ]

  before_filter :set_order, :only => [ :index ]
  before_filter :fields, :only => [ :index ]
  before_filter :form_fields, :only => [ :new, :edit, :create, :update ]

  ##
  # Application Dashboard
  #
  def dashboard
  end

  ##
  # Index
  #
  def index

    ##
    # Build the conditions
    #
    conditions = @model.build_conditions(request.env['QUERY_STRING'] || "")

    ##
    # Pagination
    #
    items_count = @model.count(:conditions => conditions)
    items_per_page = Typus::Configuration.options[:per_page].to_i
    @pager = ::Paginator.new(items_count, items_per_page) do |offset, per_page|
      @model.find(:all, 
                  :conditions => conditions, 
                  :order => @order, 
                  :limit => per_page, 
                  :offset => offset)
    end
    @items = @pager.page(params[:page])

    select_template(params[:model], 'index')

  rescue Exception => error
    error_handler(error)
  end

  def new

    item_params = params.dup
    item_params.delete_if { |key, value| key == 'action' }
    item_params.delete_if { |key, value| key == 'controller' }
    item_params.delete_if { |key, value| key == 'model' }
    item_params.delete_if { |key, value| key == 'btm' }
    item_params.delete_if { |key, value| key == 'bta' }
    item_params.delete_if { |key, value| key == 'bti' }
    @item = @model.new(item_params.symbolize_keys)

    select_template(params[:model], 'new')

  end

  def create
    @item = @model.new(params[:item])
    if @item.save
      if session[:typus_previous]

        ##
        # Recover the session
        #
        previous = session[:typus_previous]
        btm, bta, bti = previous[:btm], previous[:bta], previous[:bti]
        session[:typus_previous] = nil

        ##
        # Model to relate
        #
        model_to_relate = btm.singularize.camelize.constantize
        @item.send(btm) << model_to_relate.find(bti)

        ##
        # And finally redirect to the previous action
        #
        flash[:success] = "#{@item.class} assigned to #{btm.singularize} successfully."
        redirect_to :action => bta, :model => btm, :id => bti

      else
        flash[:success] = "#{@model.to_s.titleize} successfully created."
        redirect_to :action => 'edit', :id => @item.id
      end

    else
      render :action => 'new'
    end
  rescue Exception => error
    error_handler(error, {:params => params.merge(:action => 'index', :id => nil)} )
  end

  def edit

    ##
    # Link to previous and next, we should pass params ...
    #
    @previous = @item.previous
    @next = @item.next

    select_template(params[:model], 'edit')

  end

  ##
  # Update an item ...
  #
  def update
    if @item.update_attributes(params[:item])
      flash[:success] = "#{@model.humanize} successfully updated."
      redirect_to :action => 'edit', :id => @item.id
    else
      render :action => 'edit'
    end
  end

  ##
  # Destroy an item
  #
  def destroy
    @item.destroy
    flash[:success] = "#{@model.humanize} successfully removed."
    redirect_to :params => params.merge(:action => 'index', :id => nil)
  rescue Exception => error
    error_handler(error, { :params => params.merge(:action => 'index', :id => nil) })
  end

  ##
  # Toggle the status of an item.
  #
  def toggle
    @item.toggle!(params[:field])
    flash[:success] = "#{@model.humanize} #{params[:field]} changed."
    redirect_to :action => 'index', :params => params.merge(:field => nil, :action => 'index', :id => nil)
  end

  ##
  # Change item position
  #
  def position
    @item.send(params[:go])
    flash[:success] = "Position changed."
    redirect_to :back
  rescue Exception => error
    error_handler(error)
  end

  ##
  # Relate a model object to another.
  #
  def relate
    model_to_relate = params[:related].singularize.camelize.constantize
    @model.find(params[:id]).send(params[:related]) << model_to_relate.find(params[:model_id_to_relate][:related_id])
    flash[:success] = "#{model_to_relate.to_s.titleize} added to #{@model.humanize}."
    redirect_to :action => 'edit', :id => params[:id]
  rescue Exception => error
    error_handler(error)
  end

  ##
  # Remove relationship between models.
  #
  def unrelate
    model_to_unrelate = params[:unrelated].singularize.camelize.constantize
    unrelate = model_to_unrelate.find(params[:unrelated_id])
    @model.find(params[:id]).send(params[:unrelated]).delete(unrelate)
    flash[:success] = "#{model_to_unrelate.to_s.titleize} removed from #{@model.humanize}."
    redirect_to :action => 'edit', :id => params[:id]
  rescue Exception => error
    error_handler(error)
  end

  ##
  # Login
  #
  def login
    if request.post?
      @user = TypusUser.authenticate(params[:user][:email], params[:user][:password])
      if @user
        session[:typus] = @user.id
        redirect_to typus_dashboard_url
      else
        flash[:error] = "The Email and/or Password you entered is invalid."
        redirect_to typus_login_url
      end
    else
      render :layout => 'typus_login'
    end
  end

  ##
  # Logout and redirect to +typus_login+.
  #
  def logout
    session[:typus] = nil
    redirect_to typus_login_url
  end

  ##
  # Email password when lost
  #
  def email_password
    if request.post?
      typus_user = TypusUser.find_by_email(params[:user][:email])
      if typus_user
        password = generate_password
        host = request.env['HTTP_HOST']
        typus_user.reset_password(password, host)
        flash[:success] = "New password sent to #{params[:user][:email]}"
        redirect_to typus_login_url
      else
        flash[:error] = "Email doesn't exist on the system."
        redirect_to typus_email_password_url
      end
    else
      render :layout => 'typus_login'
    end
  end

private

  ##
  # Set current model.
  #
  def set_model
    @model = params[:model].modelize
  rescue Exception => error
    error_handler(error)
  end

  ##
  # Set default order on the listings.
  #
  def set_order
    unless params[:order_by]
      @order = @model.typus_order_by
    else
      @order = "#{params[:order_by]} #{params[:sort_order]}"
    end
  end

  # btm: Before this model
  # bta: Before this action
  # bti: Before this id
  def set_previous_action
    session[:typus_previous] = nil
    if params[:bta] && params[:btm]
      previous = Hash.new
      previous[:btm], previous[:bta], previous[:bti] = params[:btm], params[:bta], params[:bti]
      session[:typus_previous] = previous
    end
  end

  ##
  # Find
  #
  def find_model
    @item = @model.find(params[:id])
  end

  ##
  # Model +fields+
  #
  def fields
    @fields = @model.typus_fields_for('list')
  end

  ##
  # Model +form_fields+ and +form_fields_externals+
  #
  def form_fields
    @item_fields = @model.typus_fields_for('form')
    @item_has_many = @model.typus_relationships_for('has_many')
    @item_has_and_belongs_to_many = @model.typus_relationships_for('has_and_belongs_to_many')
  end

  ##
  # Before filter to check if has permission to index, edit, update & destroy a model.
  #
  def check_permissions
    unless @current_user.models.include? @model.to_s or @current_user.models.include? "All"
      flash[:notice] = "You don't have permission to manage #{params[:model].humanize.downcase}."
      redirect_to typus_dashboard_url
    end
  end

  ##
  # Select template to render
  #
  def select_template(model, template)
    if File.exists?("#{RAILS_ROOT}/app/views/typus/#{model}/#{template}.html.erb")
      render :template => "typus/#{model}/#{template}"
    else
      render :template => "typus/#{template}"
    end
  end

  ##
  #
  #
  def error_handler(error, redirection = { :action => 'dashboard' })
    unless RAILS_ENV == 'development'
      flash[:error] = error.message.titleize
      redirect_to redirection
    end
  end

end