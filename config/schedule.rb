# frozen_string_literal: true

require 'dotenv'
Dotenv.load

set :environment, ENV['RAILS_ENV']

every 1.day, at: '4:30 am' do
  runner 'Stock.update_lookup'
end
