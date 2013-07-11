class Me::FlagCountsController < Me::BaseController

  def index
    return false unless request.xhr?
    @from_me_count = 0 #Request.created_by(current_user).pending.count
    @to_me_count   = Request.to_user(current_user).pending.count
    @unread_count  = Page.count_by_path('unread',  options_for_inbox(:do => { :what => { :we =>  :want}}))
    discussions = current_user.discussions.with_some_posts.unread
    @messages_count = discussions.count
    @channel_users = channel_users_cnt
    render :layout => false
  end

  def channel_users_cnt
    if logged_in?
      @groups = current_user.all_groups
      channel_users = 0
      @groups.each do |group|
        channel_users += group.chat_channel ? group.chat_channel.users.size : 0
      end
      channel_users
    end
  end
  
  def create
    index
  end

end
