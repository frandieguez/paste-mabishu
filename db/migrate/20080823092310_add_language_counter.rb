class AddLanguageCounter < ActiveRecord::Migration
  def self.up
    add_column :languages, :pastes_count, :integer
    Language.reset_column_information
    Language.find(:all).each do |lang|
      lang.update_attribute :pastes_count, lang.pastes.size
    end
  end

  def self.down
    remove_column :languages, :pastes_count
  end
end
