ENV["AMBER_ENV"] ||= "test"

require "spec"
require "jennifer"
require "garnet_spec"

require "../config/*"
require "./support/*"

Jennifer::Config.from_uri(ENV["DATABASE_URL"]? || Amber.settings.database_url)
Jennifer::Config.logger = Logger.new(nil)

# Automatically load schema and run migrations on the test database
Jennifer::Migration::Runner.drop
Jennifer::Migration::Runner.create
Jennifer::Migration::Runner.load_schema
Jennifer::Migration::Runner.migrate

Spec.before_each do
  Jennifer::Adapter.adapter.begin_transaction
end

Spec.after_each do
  Jennifer::Adapter.adapter.rollback_transaction
end
