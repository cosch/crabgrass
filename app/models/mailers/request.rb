module Mailers::Request

  # Send an email letting the user know that a page has been 'sent' to them.
  def request_to_join_us(request, options)
    setup(options)
    accept_link = url_for(:controller => 'requests', :action => 'accept',
       :path => [request.code, request.email.gsub('@','_at_')])
    group_home = url_for(:controller => request.group.name) # tricky way to get url /groupname

    recipients request.email
    subject I18n.t(:group_invite_subject, :group => request.group.display_name)
    body({ :from => @current_user, :group => request.group, :link => accept_link,
       :group_home => group_home })
    
    # in gpg only mode we have a problem here
    # this can be used to send emails to any address
    # so we do not know the keys for
    # we try to map the mail to a user or raise an exception
    if Conf.gpg_emails_only
      user = User.find_by_email(request.email)
      if user
        ensure_encryption_if_needed user, "request_to_join_us.erb" 
      else
        raise Exception
      end
    end
  end

  def request_to_destroy_our_group(request, user)
    @group = request.group
    @user = user
    @created_by = request.created_by
    @site = Site.current ||@group.site
    @from = @site.email_sender.gsub('$current_host', @site.domain)
    @recipients = "#{user.email}"

    @subject = I18n.t(:request_to_destroy_our_group_description,
                    :group => @group.full_name,
                    :group_type => @group.group_type.downcase,
                    :user => @created_by.display_name)

    # add an explanation mark (we're using same I18n key as the activity description for this)
    @subject << "!"

    @body[:user] = @created_by
    @body[:group] = @group

    ensure_encryption_if_needed user, "request_to_destroy_our_group.text.plain.erb"
  end

end

