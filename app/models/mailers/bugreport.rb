module Mailers::Bugreport

  # Send an email letting the user know that a page has been 'sent' to them.
  def send_bugreport(params, options)
    setup(options)
    recipients options[:dev_email] 
    subject 'Crabgrass Bug Report'
    body({:site => @site, :user => @user, :backtrace => params[:full_backtrace], 
      :exception_class => params[:execption_class], :error_controller => params[:error_controller], 
      :error_action=>params[:error_action], :exception_message => params[:exception_detailed_message],
      :comments => params[:comments]})
    content_type "text/plain"

    # we try to map the dev email to an account
    Ã# or stop sending it
    if Conf.gpg_emails_only
      user = User.find_by_email(options[:dev_email])
      if user
        ensure_encryption_if_needed user, "request_to_join_us.erb"
      else
        raise Exception
      end
    end

  end

end
