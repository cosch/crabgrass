class Event < ActiveRecord::Base
  has_event_calendar :start_at_field  => 'starts_at', :end_at_field => 'ends_at'

  has_many :pages, :as => :data
  format_attribute :description

  validates_presence_of :location
  validates_presence_of :starts_at
  validates_presence_of :ends_at

  delegate :owner_name, :to => :page

  def page
      pages.first || parent_page
  end

  def page=(p)
      @page = p
  end

  def index
    self.description
  end

  def self.events_for_date_range(start_d, end_d, find_options)    
    cond = [ "starts_at > ? and ends_at < ?", start_d.to_time.utc, end_d.to_time.utc ]
    evts=  Event.find(:all, :conditions => cond)

    user = find_options[:user]
    if (user) then
      evts.delete_if { | evt | !user.may?(:view, evt.page) }
    end

    group = find_options[:group]
    if (group) then 
      evts.delete_if { | evt | !group.may?(:view,evt.page) } 
    end

    evts
  end

end
