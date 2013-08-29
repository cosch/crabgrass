module FramePageHelper
  # Return an etherpad-lite URL for the given pad, relative to the app site URL
  #
  # @param (Object) page the PadPage instance
  # @return (String) URL of the pad for iframe
  def frame_url(page = @page)
    u=URI.parse(page.external_url)
    u.to_s
  end

  # Return the HTML tag for a given etherpad-lite pad
  #
  # @param (Object) page the PadPage instance
  # @return (String) the iframe HTML tag for that pad
  def frame_iframe_show(page = @page)
    if flash[:messages].empty?
      "<div id=\"wrap\"><iframe id=\"frame\" src=\"#{frame_url(page)}\"></iframe></div>\n"
    else
      content_tag(:div, "<h3>External Service Down</h3><p>The site is not available (#{Time.now.to_s(:db)}). Please try again later.</p>", :class => "fieldWithErrors")
    end
  end

end
