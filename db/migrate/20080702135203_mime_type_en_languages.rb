class MimeTypeEnLanguages < ActiveRecord::Migration
  def self.up
    add_column :languages, :mimetype, :string, :default => "text/plain"
    Language.find :all do |language|
      language.mimetype = "text/plain"
      language.save!
    end
  end

  def self.down
    remove_column :languages, :mimetype
  end
end
