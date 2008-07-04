class Language < ActiveRecord::Base
  validates_uniqueness_of :name, :on => :create, :message => "debe ser único."
  validates_presence_of :mimetype
  #validates_presence_of :name, :on => [:create,:update], :message => "es un campo obligatorio."
  def self.count_pastes(name)
    @id_language =  Language.find_by_name(name).id
    @pastes = Paste.find_by_language_id(@id_language)
    if @pastes.nil?
      0
    else
      [@pastes].flatten.size
    end   
  end
end
