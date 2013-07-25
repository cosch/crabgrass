class Me::MessagePostsController < Me::BaseController
  prepend_before_filter :fetch_recipient

  def create
    if( @recipient_group )
      create_for_group
    else
      create_for_user
    end
  end

  def create_for_group
    prefix = I18n.t(:message_recipient_name_caption, :user => @recipient_group.name)
    params[:post][:body] = prefix +"\n"+params[:post][:body]
    names =""
    @recipient_group.memberships.with_users.each do |m| 
      if (m.user!=current_user && m.user.may_be_pestered_by?(current_user))
        send_to_user m.user 
        names+=m.user.login+", "
      end
    end
    
    names = names[0..-3]
    flash_message :info => I18n.t(:message_sent, :names => names)

    respond_to do |wants|
      wants.html { redirect_to messages_path }
      wants.js { render :nothing => true }
    end
  end

  def create_for_user
    send_to_user @recipient

    flash_message :info => I18n.t(:message_sent, :names => @recipient.login) 
    respond_to do |wants|
      wants.html { redirect_to message_path(@recipient.login) }
      wants.js { render :nothing => true }
    end
  end

  def send_to_user( recipient )
    in_reply_to = Post.find_by_id(params[:in_reply_to_id])
    current_user.send_message_to!(recipient, params[:post][:body], in_reply_to)
  end

  protected

  def fetch_recipient
    @recipient=nil
    @recipient_group=nil

    @recipient_group = Group.find_by_name( params[:message_id] ) if Conf.private_message_to_group?

    if (!@recipient_group )
      @recipient = User.find_by_login(params[:message_id])
      if @recipient.blank?
        flash_message :error => I18n.t(:message_recipent_not_found)
        redirect_to messages_path 
      end
    end
  end

  def authorized?
    if current_user == @recipient
      flash_message :error => I18n.t(:message_to_self_error)
      redirect_to messages_path
    elsif !@recipient_group && !@recipient
      flash_message :error => I18n.t(:message_recipent_not_found)
      redirect_to messages_path
    elsif @recipient_group && !current_user.member_of?(@recipient_group)
      flash_message :error => I18n.t(:message_cant_group_error, :group => @recipient_group.name)
      redirect_to messages_path
    elsif @recipient && !@recipient.may_be_pestered_by?(current_user)
      flash_message :error => I18n.t(:message_cant_perster_error, :user => @recipient.name)
      redirect_to messages_path
    end

    true
  end
end
