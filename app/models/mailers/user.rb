module Mailers::User

  def forgot_password(token, options)
    setup(options)
    setup_email(token.user)
    @subject += I18n.t(:requested_forgot_password)
    @body[:url] = url_for(:controller => 'account', :action => 'reset_password', :token => token.value)

    ensure_encryption_if_needed token.user, "forgot_password.text.plain.erb"
  end

  def reset_password(user, options)
    setup(options)
    setup_email(user)
    @subject += I18n.t(:password_was_reset)

    ensure_encryption_if_needed user, "reset_password.text.plain.erb"
  end

  def unread_messages(user)
    @recipients = "#{user.email}"
    @from = "system"
    @sent_on = Time.now
    @body[:user] = user
    @subject = I18n.t(:unread_msg_waiting)

    ensure_encryption_if_needed user, "deliver_unread_messages.text.plain.erb"
  end

  protected

  def setup_email(user)
    @recipients   = "#{user.email}"
    @from         = "%s <%s>" % [I18n.t(:reset_password), @from_address]
    @subject      = @site.title + ": "
    @sent_on      = Time.now
    @body[:user]  = user
  end

end

