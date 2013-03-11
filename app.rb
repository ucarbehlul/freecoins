# encoding: UTF-8
# Require all the things!
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
  # DATABASE_URL is provided by Herkou, or can be set on the command line
  #
  # For instance: DATABASE_URL=mysql://localhost/freecoins rackup
  # will run the app with the database at localhost/freecoins.
  DataMapper.setup(:default, ENV['DATABASE_URL'])
  # These set it up to automatically create/change tables when
  # their models are updated.
  DataMapper.auto_migrate!
  DataMapper.auto_upgrade!

  # Here we read in the config file and parse the JSON from it.
  config = JSON.parse(File.read("config.json"))

  # Then we loop through each element in the JSON object and
  # assign it to Sinatra's settings.
  #
  # They are accessed via settings.key anywhere in the app,
  # especially in some of the routes.
  config.each do |k, v|
    set k.to_sym, v
  end
end

require_relative 'helpers/init'

require_relative 'models/init'
# This has to be called once all the models have been defined.
DataMapper.finalize

require_relative 'routes/init'
