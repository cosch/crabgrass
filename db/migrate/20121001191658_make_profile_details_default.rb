class MakeProfileDetailsDefault < ActiveRecord::Migration
  def self.up
    change_table :profiles do |t|
      t.change_default(:may_see_committees, true)
      t.change_default(:may_see_networks, true)
      t.change_default(:may_see_groups, true)
      t.change_default(:may_see_contacts, true)
    end
  end

  def self.down
    change_table :profiles do |t|
      t.change_default(:may_see_committees, false)
      t.change_default(:may_see_networks, false)
      t.change_default(:may_see_groups, false)
      t.change_default(:may_see_contacts, false)
    end
  end
end
