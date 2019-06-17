require 'pry'
require 'require_all'
require 'poke-api-v2'
require 'bundler'
require 'rake'
require 'active_record'

require_all 'lib'

Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')