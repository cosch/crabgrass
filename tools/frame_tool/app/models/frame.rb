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
  before_save :update_page_terms, :ensure_no_base_url

  has_one :page, :as => :data

  def external_url
  	if Conf.external_url_tool_only_relative?
  		if (url.start_with? Conf.external_url_tool_base)
  			ensure_no_base_url
  			save
  		end

		u = url
		slash = "/"
		u=u[1..-1] if (Conf.external_url_tool_base.end_with?(slash) && u.start_with?(slash))
		slash = "" if Conf.external_url_tool_base.end_with?(slash) || u.start_with?(slash)		
		return Conf.external_url_tool_base+slash+u
  	end
  	url
  end

  def external_url=(val)  
  	url=val
  	ensure_no_base_url if Conf.external_url_tool_only_relative?
  end

  def ensure_no_base_url
  	return if !Conf.external_url_tool_only_relative? 
  	return if !self.url
  	
    self.url=self.url.gsub Conf.external_url_tool_base, ""    
  end

  def update_page_terms
    self.page_terms = page.page_terms unless page.nil?
  end

  private

  def url
  	self[:url]
  end

  def url=(val)
  	self[:url]=val
  end

end

