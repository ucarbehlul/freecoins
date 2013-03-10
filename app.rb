# encoding: UTF-8
require 'sinatra'
require 'haml'
require 'digest'
require 'net/http'
require 'data_mapper'
require 'nestful'
require 'letters'
require 'time_diff'
require 'maruku'

configure do
  enable :sessions
  set :session_secret, "freecoins"
  DataMapper.setup(:default, ENV['DATABASE_URL'])
  DataMapper.auto_migrate!
  DataMapper.auto_upgrade!

  config = JSON.parse(File.read("config.json"))

  config.each do |k, v|
    set k.to_sym, v
  end
end

require_relative 'helpers/init'

require_relative 'models/init'
DataMapper.finalize

require_relative 'routes/init'
