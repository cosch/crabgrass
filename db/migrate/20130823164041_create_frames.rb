class CreateFrames < ActiveRecord::Migration  
  def self.up
    create_table :frames do |t|
      t.string     :name
      t.string     :url
      t.references :page

      t.timestamps
    end
    add_index :frames, :page_id, :unique => true
  end

  def self.down
    drop_table :frames
  end
end