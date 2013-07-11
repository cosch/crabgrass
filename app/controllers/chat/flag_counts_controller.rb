class Chat::FlagCountsController < ApplicationController

  def create
    return false unless request.xhr?
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

end
