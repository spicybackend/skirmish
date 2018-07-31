ENV["AMBER_ENV"] ||= "test"

require "spec"
require "micrate"
require "garnet_spec"

require "../config/*"
require "./support/*"

Micrate::DB.connection_url = ENV["DATABASE_URL"]? || Amber.settings.database_url

# Automatically run migrations on the test database
Micrate::Cli.run_up

# Disable Granite logs in tests
Granite.settings.logger = Logger.new nil

