class AnhadirIdLanguageUltraviolet < ActiveRecord::Migration
  def self.up
    add_column :languages, :uv_name, :string
  end

  def self.down
    remove_column :languages, :uv_name
  end
end
