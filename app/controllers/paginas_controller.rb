class PaginasController < ApplicationController
  before_filter :load_languages, :admin
  def index
    redirect_to(root_path)
  end
  def show
    begin
      @pagina = Pagina.find_by_link(params[:pagina])
      raise if @pagina.nil?
    rescue 
      @pagina = Pagina.find :first
      flash[:notice] = "Seica houbo problemas"
    end
    respond_to do |format|
      format.html
    end
    
  end
end
