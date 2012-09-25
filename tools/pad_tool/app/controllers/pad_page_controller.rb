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
    @pad.sync!
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
    if Conf.pad_url
      custom_url = true
      uri = URI.parse(Conf.pad_url)
      ssl = (uri.scheme=='https')
      host = uri.host
    end
    cookies['sessionID'] = {
      :value    => sess_id,
      :domain   => (custom_url ? host : request.host),
      :path     => '/',
      :expires  => Time.now + 60 * EPL::ETHERPAD_SESSION_DURATION,
      :secure   => (custom_url ? ssl : request.ssl?)
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
    @pad
  end
end
