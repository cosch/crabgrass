class MakeProfileDefaultsFalseForGroups < ActiveRecord::Migration
  def self.up
    change_table :profiles do |t|
      t.change_default(:may_see_committees, false)
    end
  end

  def self.down
    change_table :profiles do |t|
      t.change_default(:may_see_committees, false) 
    end
  end
end
