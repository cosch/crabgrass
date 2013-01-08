DIR = File.dirname(__FILE__)
require DIR + '/../../config/environment'

puts "running 5minutes workers on #{Rails.env}"

 
def send_pending_single_notifications_for_watched_pages
  puts "send_pending_single_notifications_for_watched_pages"
  PageHistory.send_single_pending_notifications
end

# remove stale users from chat rooms.
# this should be called every minute.
def clean_chat_channels_users
  puts "clean_chat_channels_users"
  ChatChannel.cleanup!
end

def unread_messages
  puts "unread_messages"
  User.all.each do |u| 
    u.send_unread_msg_mail
  end  
end  


send_pending_single_notifications_for_watched_pages
clean_chat_channels_users
unread_messages

puts "5minutes workers done...."



