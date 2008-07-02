class PastesController < ApplicationController
  before_filter :load_languages
  # GET /pastes
  # GET /pastes.xml
  def index
    @pastes = Paste.find(:all, :order => "created_at DESC")
    @languages = Language.find :all, :order => "name"
  end

  # GET /pastes/1
  # GET /pastes/1.xml
  def show
    @paste = Paste.find(params[:id])
    @language = Language.find(@paste.language_id)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @paste }
      format.text { render :text => "Escrito en :#{Language.find(@paste.language_id).name}\n------------------------------------\n\n"+@paste.content.to_s}
    end
  end

  # GET /pastes/new
  # GET /pastes/new.xml
  def new
    @paste = Paste.new
    @languages = Language.find :all, :order => "name"
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
        format.html { redirect_to(@paste) }
        format.xml  { render :xml => @paste, :status => :created, :location => @paste }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @paste.errors, :status => :unprocessable_entity }
      end
    end
  end
 def search
  @pastes = Paste.find :all, :conditions =>"content LIKE '%#{params[:q]}%'"
  
  respond_to do |format|
    format.html
    format.xml { render :xml => @pastes}
  end
 end
 def download
   @paste = Paste.find(params[:id])
   @lenguaje = Language.find(@paste.language_id)
   send_data @paste.content.to_s,
        :type => @lenguaje.mimetype,
        :disposition => "attachment",
        :filename => "#{@paste.id}.#{@lenguaje.extension}"
 end
 private
 def load_languages
   @languages = Language.find :all, :order => "name"
 end
end
