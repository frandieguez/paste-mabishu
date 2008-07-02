class LanguagesController < ApplicationController
  # GET /languages
  # GET /languages.xml
  def index
    @languages = Language.find(:all, :order => "name")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @languages }
    end
  end

  # GET /languages/1
  # GET /languages/1.xml
  def show
    @language = Language.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @language }
    end
  end
end
