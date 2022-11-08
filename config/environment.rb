require 'bundler'
Bundler.require

require_relative '../lib/dog'

DB = { conn: SQLite3::Database.new("db/dogs.db") }

DB[:conn].results_as_hash = true

Dog.create_table
