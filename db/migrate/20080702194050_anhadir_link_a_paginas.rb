class AnhadirLinkAPaginas < ActiveRecord::Migration
  def self.up
    add_column :paginas, :link, :string
  end

  def self.down
    remove_column :paginas, :link
  end
end
