class AdminMailer < Mailer
  def blast(user, options)
    setup(options)
    setup_user(user)

    @subject += options[:subject]
    body :message => options[:body]

    ensure_encryption_if_needed user, "blast"
  end


  def notify_inappropriate(user, options)
    setup(options)
    setup_user(user)
    @subject += "Inappropriate Content"
    body :message => options[:body], :url => link(options[:url]), :owner => options[:owner]

    ensure_encryption_if_needed user
  end

  protected

  def setup_user(user)
    @recipients   = "#{user.email}"
    @from         = @from_address
    @subject      = @site.title + ": "
    @sent_on      = Time.now
    @body[:user]  = user
  end

end
