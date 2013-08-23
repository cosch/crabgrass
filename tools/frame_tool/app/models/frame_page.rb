
class FramePage < Page
  alias_method :frame, :data
  
  # :ep_full_pad_name returns 'group_id$pad_id', suitable for URLs
  def external_url
    @external_url="http://www.ccc.de"
    #@external_url ||= frame.external_url if frame.respond_to?(:name)
  end

  
end
