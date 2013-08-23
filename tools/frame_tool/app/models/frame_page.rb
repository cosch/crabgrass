
class FramePage < Page
  alias_method :frame, :data
  before_create :create_frame
  
  # :ep_full_pad_name returns 'group_id$pad_id', suitable for URLs
  def external_url
    if frame
      frame.external_url  
    else
      "http://www.ccc.de"
    end
    #@external_url ||= frame.external_url if frame.respond_to?(:name)
  end

  def create_frame
    self.data = Frame.create 
    frame.external_url="http://heise.de"
  end
  
end
