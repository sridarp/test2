# Use this file to easily define all of your cron jobs.

# Learn more: http://github.com/jmettraux/rufus-scheduler

require 'rufus-scheduler'
require 'rake'

scheduler = Rufus::Scheduler.new

scheduler.every '24h' do
  system('bundle exec rake upkeep:prune_alerts')
end

scheduler.every '15m' do
  system('bundle exec rake upkeep:update_budgets')
end
