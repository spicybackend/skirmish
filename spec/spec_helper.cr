ENV["AMBER_ENV"] ||= "test"

require "spec"
require "jennifer"
require "garnet_spec"

require "../config/*"
require "./support/*"

Jennifer::Config.from_uri(Amber.settings.database_url)

# Automatically run migrations on the test database
Jennifer::Migration::Runner.migrate

# Disable database logs in tests
Jennifer::Config.configure do |conf|
  conf.logger = Logger.new(nil)
end

Spec.before_each do
  Jennifer::Adapter.adapter.begin_transaction
end

Spec.after_each do
  Jennifer::Adapter.adapter.rollback_transaction
end
