class PaginasController < ApplicationController
  def show
    begin
      @languages = Language.find :all
      @pagina = Pagina.find_by_link(params[:pagina].to_s)
      raise unless !pagina.nil?
    rescue 
      @pagina = Pagina.find :first
      flash[:notice] = "Seica houbo problemas"
    end
    respond_to do |format|
      format.html
      format.xml {render :xml => @pagina.to_xml}
      format.json {render :json => @pagina.to_json}
      format.txt {render :text => "hola mundo"}
    end
    
  end
end
