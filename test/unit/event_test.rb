require File.dirname(__FILE__) + '/../test_helper'

class EventTest < ActiveSupport::TestCase
  fixtures :users, :events, :profiles, :sites, :groups, :pages, :memberships, :user_participations, :group_participations
  
  def setup
    enable_site_testing
    @s = Date.civil( Time.zone.now.year.to_i, Time.zone.now.month.to_i).to_time
    @e = Date.civil( Time.zone.now.year.to_i, Time.zone.now.month.to_i+1).to_time

    @s_n = Date.civil( Time.zone.now.year.to_i, Time.zone.now.month.to_i+1).to_time
    @e_n = Date.civil( Time.zone.now.year.to_i, Time.zone.now.month.to_i+2).to_time
  end

  def teardown
    disable_site_testing
  end


  def test_finding_month_events
    cond = { }
    evts = Event.events_for_date_range(@s,@e,cond)

    assert_equal 3, evts.count, "Should find 3 events"

    evts.each do | e |  
      assert_equal true, (e.starts_at > @s && e.ends_at < @e), "Event should be in this month"
    end
  end

  def test_finding_next_month_events
    cond = { }

    evts = Event.events_for_date_range(@s_n,@e_n,cond)
    assert_equal 2, evts.count, "Should find 2 events"
    evts.each do |e| 
	assert_equal true, (e.starts_at > @s_n && e.ends_at < @e_n), "Event should be in next month"
    end
  end

  def test_finding_events_for_user_only
    user = users(:blue)
    
    cond = { :user => user }
    evts = Event.events_for_date_range(@s,@e,cond)
    assert_equal 1, evts.count, "Should find 1 events"
    evts.each do |e|
        assert_equal true, (e.starts_at > @s && e.ends_at < @e), "Event should be this month"        
    end
  end

  def test_finding_events_with_unauth_user
    user = UnauthenticatedUser.new
    cond = { :user => user }
    evts = Event.events_for_date_range(@s,@e,cond)
    assert_equal 0, evts.count, "Should find 0 events"
  end

  def test_finding_events_from_groups_for_user
    user = users(:blue)
    cond = {:user=>user }

    evts = Event.events_for_date_range(@s_n,@e_n,cond)
    assert_equal 1, evts.count, "Should find 1 events for blue from rainbows group"
    evts.each do |e|
        assert_equal true, (e.starts_at > @s_n && e.ends_at < @e_n), "Event should be in next month"
    end
  end

  def test_finding_events_from_unauthed_group_user
    user = users(:dolphin)
    cond = {:user=>user }

    evts = Event.events_for_date_range(@s_n,@e_n,cond)
    assert_equal 0, evts.count, "Should find 0 events for dolphin from animal group"
    evts.each do |e|
        assert_equal true, (e.starts_at > @s_n && e.ends_at < @e_n), "Event should be in next month"
    end
  end

  def test_finding_events_from_group_for_group
    group = groups(:rainbow)
    cond = {:group=>group } 

    evts = Event.events_for_date_range(@s_n,@e_n,cond)
    assert_equal 1, evts.count, "Should find 1 events for rainbow group"
    evts.each do |e|
        assert_equal true, (e.starts_at > @s_n && e.ends_at < @e_n), "Event should be in next month"
    end
  end  

  def test_finding_events_from_different_group_for_group
    group = groups(:animals)
    cond = {:group=>group }

    evts = Event.events_for_date_range(@s_n,@e_n,cond)
    assert_equal 0, evts.count, "Should find 0 events for animal group"
    evts.each do |e|
        assert_equal true, (e.starts_at > @s_n && e.ends_at < @e_n), "Event should be in next month"
    end
  end
end
