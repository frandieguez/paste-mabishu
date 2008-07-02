class CreatePastes < ActiveRecord::Migration
  def self.up
    create_table :pastes do |t|
      t.text :content
      t.integer :language_id

      t.timestamps
    end
  end

  def self.down
    drop_table :pastes
  end
end
