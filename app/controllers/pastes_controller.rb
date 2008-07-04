class PastesController < ApplicationController
  before_filter :load_languages, :load_themes
  # GET /pastes
  # GET /pastes.xml
  def index
    unless read_fragment({})

      @pastes = Paste.find(:all, :order => "created_at DESC").paginate :page => params[:page], :per_page => 4
    end
  end

  # GET /pastes/1
  # GET /pastes/1.xml
  def show
    @paste = Paste.find(params[:id], :include => :language)
    @contenido =
    begin
  			Uv.parse(@paste.content.to_s, "xhtml", "actionscript", true, @theme )
  	rescue ArgumentError
  			flash[:notice] = "Non se pode elexir esa configuración"
  		  Uv.parse(@paste.content.to_s, "xhtml", "actionscript", true, "blackboard")
  	end
  	
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @paste }
      format.text { render :text => "Paste #{@paste.id} \nEscrito en: #{@paste.language.name}\n------------------------------------\n\n"+@paste.content.to_s}
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
  @pastes << Paste.find_tagged_with( params[:q])
  @pastes.flatten!
  respond_to do |format|
    format.html
    format.xml { render :xml => @pastes}
  end
 end
 def download
   @paste = Paste.find(params[:id])
   send_data @paste.content.to_s,
        :type => @paste.language.mimetype,
        :disposition => "attachment",
        :filename => "#{@paste.id}.#{@lenguaje.extension}"
 end
end
