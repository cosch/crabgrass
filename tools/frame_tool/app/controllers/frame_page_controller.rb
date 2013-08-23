class FramePageController < BasePageController

  permissions 'frame_page'

  before_filter :fetch_user_participation  

  def show
  end

  def edit
  end

  ##
  ## PROTECTED
  ##
  protected

  # :nodoc: load the correct page Class
#  def page_type
#    PadPage
#  end

  def fetch_user_participation
    @upart = @page.participation_for_user(current_user) if @page and current_user
  end

  def build_page_data
  end
end
