# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
#set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

RAILS_ENV=ENV['RAILS_ENV'] || 'production'
RAILS_ROOT= File.expand_path(File.join(File.dirname(__FILE__),"..")) 

RBENV="export RBENV_ROOT=/usr/local/rbenv && export PATH=\"$RBENV_ROOT/bin:$PATH\" && eval \"$(rbenv init -)\" && export RAILS_ENV=#{RAILS_ENV} && "

set :output, "#{RAILS_ROOT}/log/#{RAILS_ENV}.log"
set :job_template, "/usr/local/bin/bash -l -c ':job'"

every 1.day, :at => '2:30am' do
  command "#{RBENV} cd #{RAILS_ROOT} && ruby #{RAILS_ROOT}/lib/crons/daily.rb"  
end

every 1.hours do
  command "#{RBENV} cd #{RAILS_ROOT} && ruby #{RAILS_ROOT}/lib/crons/hourly.rb"
end

every 5.minutes do
  command "#{RBENV} cd #{RAILS_ROOT} && ruby #{RAILS_ROOT}/lib/crons/5minutes.rb"
end

