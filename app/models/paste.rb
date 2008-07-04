class Paste < ActiveRecord::Base
  belongs_to :language
  acts_as_taggable
  
end
