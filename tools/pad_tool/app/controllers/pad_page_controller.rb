class PadPageController < BasePageController

  permissions 'pad_page'

  before_filter :refresh_epl_session, :only => [:show, :print]
  before_filter :fetch_user_participation  

  def show
  end

  def edit
  end

  ##
  ## PROTECTED
  ##
  protected

  def refresh_epl_session
    debugger
    @pad = @page.pad
    session[:ep_sessions] ||= {}
    sess = @pad.update_session(session[:ep_sessions])
    session[:ep_sessions][@pad.name] = sess.id 
    save_ep_session_cookie(sess.id)
  rescue Errno::ECONNREFUSED
    error("Connection to Etherpad-Lite failed: service unavailable.", :now)
  rescue Exception => e
    error "NO ETHERPAD SESSION! #{e.class}: #{e.message}" # should deny permission?
  end

  # Set the EtherpadLite session cookie.
  # This will automatically be picked up by the jQuery plugin's iframe.
  def save_ep_session_cookie(sess_id)
    cookies['sessionID'] = {
      :value    => sess_id,
      :domain   => request.host,
      :path     => '/',
      :expires  => Time.now + 60 * EPL::ETHERPAD_SESSION_DURATION,
      :secure   => request.ssl?
    }
  end

  # :nodoc: load the correct page Class
#  def page_type
#    PadPage
#  end

  def fetch_user_participation
    @upart = @page.participation_for_user(current_user) if @page and current_user
  end

  def build_page_data
  #  unless params[:asset][:uploaded_data].any?
  #    @page.errors.add_to_base I18n.t(:no_data_uploaded)
  #    raise ActiveRecord::RecordInvalid.new(@page)
  #  end

  #  asset = Asset.build params[:asset]
  #  @page[:title] = asset.basename unless @page[:title].any?
  #  asset
    @pad
  end
end