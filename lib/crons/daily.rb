DIR = File.dirname(__FILE__)
require DIR + '/../../config/environment'

puts "running daily workers on #{Rails.env}"

def send_pending_digest_notifications_for_watched_pages
  puts "send_pending_digest_notifications_for_watched_pages"
  PageHistory.send_digest_pending_notifications
end

def clean_fragment_cache
  puts "clean_fragment_cache"
  # remove all files that have had their status changed more than three days ago.
  system("find", RAILS_ROOT+'/tmp/cache', '-ctime', '+3', '-exec', 'rm', '{}', ';')
  # (on a system with user accounts, tmpreaper should be used instead.)
end

def clean_session_cache
  puts "clean_fragment_cache"
  # remove all files that have had their status changed more than three days ago.
  system("find", RAILS_ROOT+'/tmp/sessions', '-ctime', '+3', '-exec', 'rm', '{}', ';')
  # (on a system with user accounts, tmpreaper should be used instead.)
end

def clean_codes
  puts "clean_codes"
  Code.cleanup_expired
end

# updates dailies from the data in the hourlies table.
# this should be called once per day.
def update_dailies
  puts "update_dailies"
  Daily.update
end

def rebuild_sphinx
  puts "rebuild index_sphinx"
  system('rake', '--rakefile', RAILS_ROOT+'/Rakefile', 'ts:rebuild', 'RAILS_ENV=production')
end

send_pending_digest_notifications_for_watched_pages
clean_fragment_cache
clean_session_cache
clean_codes
update_dailies
rebuild_sphinx

puts "daily workers done...."



