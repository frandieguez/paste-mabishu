class Language < ActiveRecord::Base
  validates_uniqueness_of :name, :on => :create, :message => "debe ser único."
  validates_presence_of :mimetype
  #validates_presence_of :name, :on => [:create,:update], :message => "es un campo obligatorio."
  has_many :pastes
end
