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

  # def ext_url
  # 	if Conf.external_url_tool_only_relative?
  # 		if (url.starts_with? Conf.external_url_tool_base)
  # 			return url
  # 		else
  # 			return Conf.external_url_tool_base+url
  # 		end
  # 	end
  # 	url
  # end

  # def ext_url=(val)
  # 	url=val
  # end

  # def ensure_no_base_url
  # 	return if !Conf.external_url_tool_only_relative? 

  # 	puts "oshie #{url}"
  #   url.gsub Conf.external_url_tool_base, ""
  #   puts "oshie done #{url}"
  # end

  # def save!
  #   ensure_no_base_url if Conf.external_url_tool_only_relative?
  #   super.save!
  # end

  # def save
  #   ensure_no_base_url if Conf.external_url_tool_only_relative?
  #   super.save
  # end

  # these are used during creation when name has not been set
  #attr_accessor :url
  #validates_presence_of :name

  def update_page_terms
    self.page_terms = page.page_terms unless page.nil?
  end

  # private

  # def url
  # 	self[:url]
  # end

  # def url=(val)
  # 	self[:url]=val
  # end
end

