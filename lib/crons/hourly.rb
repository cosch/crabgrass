DIR = File.dirname(__FILE__)
require DIR + '/../../config/environment'

puts "running hourly workers on #{Rails.env}"

# updates page.views_count and hourlies from the data in the trackings table.
# this should be called frequently.
def process_trackings
  puts "process_trackings"
  Tracking.process
end

# the output of this is logged to: log/backgroundrb_debug_11006.log
# if debug_log == true in backgroundrb.yml
def reindex_sphinx
  puts "reindex_sphinx"
  system('rake', '--rakefile', RAILS_ROOT+'/Rakefile', 'ts:index', 'RAILS_ENV=production')
end

def tally_votes
  puts "tally_votes"
  RequestToDestroyOurGroup.tally_votes!
end

process_trackings
reindex_sphinx
tally_votes

puts "hourly workers done...."



