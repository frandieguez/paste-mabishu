class Pagina < ActiveRecord::Base
  validates_format_of :link, :with => /^[\w\d]+$/, :on => :create, :message => "solo puede contener dígitos y letras"
end
  