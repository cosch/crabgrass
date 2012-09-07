class AdminMailer < Mailer
  def blast(user, options)
    setup(options)
    setup_user(user)

    if Conf.gpg_emails_only

	@subject = I18n.t(:gpg_subject)
	encrypt = has_matching_keyring(user)
        
        if encrypt
	   keyring = encrypt[:keyring]
           fingerprint = encrypt[:fingerprint]
	   body :message => keyring.encrypt_to(fingerprint, options[:body])
        elsif
           body :message => I18n.t(:gpg_missing_key)
        end

    else

      @subject += options[:subject]
      body :message => options[:body]

    end
  end


  def notify_inappropriate(user, options)
    setup(options)
    setup_user(user)
    @subject += "Inappropriate Content"
    body :message => options[:body], :url => link(options[:url]), :owner => options[:owner]
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
