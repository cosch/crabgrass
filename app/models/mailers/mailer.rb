=begin

Multiple recipients
-------------------

It would be much much more efficient to send all the emails in one blast,
using multiple recipients or bcc. However, this makes the social network
data available to anyone intercepting a single email. BCC is better, but
we might as well address each email to each person individually.

Mailer options
--------------

There are various tricks you can use to get around the fact that mailers
are models and don't have access to the request or the session.

In our case, we can't use these: the mailer needs to know that request and
sessiond data, because there might be multiple sites, each with their own
domain, running on the same instances of rails.

So, we have ApplicationController#mailer_options(). This bundles up everything
from the session that is needed for the mailer to get the domain and the
protocol right.

Every call to deliver should include as its last argument the mailer_options.
For example:

   Mailer::Page.deliver_page_notice(user, message, mailer_options)

Then, every mailer method should do this as its first line:

   setup(options)


=end

class Mailer < ActionMailer::Base
  include ActionController::UrlWriter
  include Mailers::Page
  include Mailers::User
  include Mailers::Group
  include Mailers::Request
  include Mailers::Bugreport
  include Mailers::Verification
  include Mailers::PageHistory

  protected

  def link(path=nil)
    if path
      [@protocol,@host,@port,'/',path.sub(/^\//, '')].join
    else
      [@protocol,@host,@port].join
    end
  end

  def setup(options)
    @site = options[:site]
    @user = options[:user]
    @current_user = options[:current_user]
    @page = options[:page]
    @site = options[:site]
    @from_address = options[:from_address]
    @from_name = options[:from_name]
    @from = "%s <%s>" % [@from_name, @from_address]

    @host = default_url_options[:host] = options[:host]
    @port = default_url_options[:port] = options[:port] if options[:port]
    @port = ':' + @port if @port and @port !~ /^:/
    @protocol = default_url_options[:protocol] = options[:protocol]
    default_url_options[:only_path] = false
  end


  def ensure_encryption_if_needed( user , layout=nil )
    if Conf.gpg_emails_only

      # make sure we have plain text
      # and move the subject to body
      content_type "text/plain"
      rendered = @subject+"\n\n"+render_message(layout,@body) if layout
      transfer_encoding = "base64"

      #override the subject for security reasons
      @subject = I18n.t(:gpg_subject)

      # encrypt if we have a key
      # or write gpg missing text
      encrypt = has_matching_keyring(user)      
      if encrypt
         keyring = encrypt[:keyring]
         fingerprint = encrypt[:fingerprint]
         @body = keyring.encrypt_to(fingerprint, rendered)
      elsif
         @body = I18n.t(:gpg_missing_key)
      end

      # override the "from"
      @from_address = I18n.t(:gpg_from_address)
      @from_name = I18n.t(:gpg_from_name)
      @from = "%s <%s>" % [@from_name, @from_address]
    end
  end


  def has_matching_keyring(user)
    ret = nil
    return ret if !user.email

    user.profiles.each do |profile|
      profile.crypt_keys.each do |key|
        if( key.name.include?(user.email) )
          ret = {
                  :keyring => Keyring.new(key.keyring),
                  :fingerprint => key.fingerprint
                }
          break
        end
      end
    end

    ret                                            
  end

end
