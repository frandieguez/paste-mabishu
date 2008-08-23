class Paste < ActiveRecord::Base
  belongs_to :language, :counter_cache => true
  acts_as_taggable  
end
