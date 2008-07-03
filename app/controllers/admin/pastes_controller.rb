class Admin::PastesController < ApplicationController
  layout "admin"
  before_filter :load_languages
  before_filter :load_themes
  # GET /pastes
  # GET /pastes.xml
  def index
    @pastes = Paste.find(:all, :order => "created_at DESC").paginate :page => params[:page], :per_page => 5
  end

  # GET /pastes/1
  # GET /pastes/1.xml
  def show
    @paste = Paste.find(params[:id])
    @language = Language.find(@paste.language_id).name

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @paste }
    end
  end
  def edit
    @paste = Paste.find(params[:id])
  end
  
  def update
    @paste = Paste.find(params[:id])

    respond_to do |format|
      if @paste.update_attributes(params[:pagina])
        flash[:notice] = 'O teu paste foi actualizado correctamente.'
        format.html { redirect_to([:admin,@paste]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @paste.errors, :status => :unprocessable_entity }
      end
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
        flash[:notice] = 'O teu Paste foi creado correctamente.'
        format.html { redirect_to([:admin,@paste]) }
        format.xml  { render :xml => @paste, :status => :created, :location => @paste }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @paste.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @paste = Paste.find(params[:id])
    @paste.destroy unless @paste.nil?
    flash[:notice] = "A Paste #{@paste.id} foi eliminada"
    redirect_to(pastes_path)
  end
  def search
   @pastes = Paste.find :all, :conditions =>"content LIKE '%#{params[:q]}%'"

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
