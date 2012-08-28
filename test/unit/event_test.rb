require File.dirname(__FILE__) + '/../test_helper'

class EventTest < ActiveSupport::TestCase
  fixtures :users, :events, :profiles, :sites, :groups
  
  def setup
    enable_site_testing
  end

  def teardown
    disable_site_testing
  end


  def test_finding_month_events
    true
  end

  def test_finding_next_month_events
    true
  end

  def test_finding_events_for_user_only
    user = users(:blue)
  end

  def test_finding_events_with_unauth_user
    user = UnauthenticatedUser.new
    true
  end

  def test_finding_events_from_groups_for_user
    user = users(:blue)
    true
  end

  def test_finding_events_from_unauthed_group_suer
    user = users(:red)
    true
  end

end
