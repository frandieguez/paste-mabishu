class ExtensionEnLenguages < ActiveRecord::Migration
  def self.up
    add_column :languages, :extension, :string
  end

  def self.down
    remove_column :languages, :extension
  end
end
