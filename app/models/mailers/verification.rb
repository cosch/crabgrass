module Mailers::Verification

  # Send an email letting the user know that a page has been 'sent' to them.
  # -this does not seem to be true anymore-
  def email_verification(token, options)
    setup(options)

    recipients @current_user.email
    subject I18n.t(:welcome_title, :site_title => @site.title)

    body({:site_title => @site.title,
            :link => account_verify_url(:token => token.value),
            :host => @host})

    # we can not encrypt the signup mail verification
    # as we do not have a key here yet
    if Conf.gpg_emails_only
      raise Exception
    end
  end

end

