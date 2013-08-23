#
# = Model
#
# create_table do |t|
#   t.integer :page_id
#   t.string  :name
#   t.blob    :text
#   t.string  :url
# end

class Frame < ActiveRecord::Base
  include PageData
  before_save :update_page_terms

  has_one :page, :as => :data

  # these are used during creation when name has not been set
  attr_accessor :external_url
  validates_presence_of :name
  
  def sync!
    sync and save
  end

  protected

  def sync
  end

  def update_session(old_sessions)
  end

  def update_page_terms
    self.page_terms = page.page_terms unless page.nil?
  end
end

