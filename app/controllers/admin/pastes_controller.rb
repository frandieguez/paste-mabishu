class Admin::PastesController < ApplicationController
  layout "admin"
  before_filter :load_languages
  # GET /pastes
  # GET /pastes.xml
  def index
    @pastes = Paste.find(:all, :order => "created_at DESC")
  end

  # GET /pastes/1
  # GET /pastes/1.xml
  def show
    @paste = Paste.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @paste }
    end
  end

  # GET /pastes/new
  # GET /pastes/new.xml
  def new
    @paste = Paste.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @paste }
    end
  end
  def create
    @paste = Paste.new(params[:paste])

    respond_to do |format|
      if @paste.save
        flash[:notice] = 'Paste was successfully created.'
        format.html { redirect_to([:admin,@paste]) }
        format.xml  { render :xml => @paste, :status => :created, :location => @paste }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @paste.errors, :status => :unprocessable_entity }
      end
    end
  end
 def search
  @pastes = Paste.find_by_content(params[:q])
  
  respond_to do |format|
    format.html
    format.xml { render :xml => @pastes}
  end
 end
 private
 def load_languages
   @languages = Language.find :all, :order => "name"
 end
end
