require "colorize"
require "jennifer"
require "jennifer/adapter/postgres"

database_url = ENV["DATABASE_URL"]? || Amber.settings.database_url

Jennifer::Config.from_uri(database_url)
Jennifer::Config.configure do |conf|
  conf.logger = Logger.new(STDOUT)

  conf.logger.formatter = Logger::Formatter.new do |severity, datetime, progname, message, io|
    io << datetime.colorize(:cyan) << ": \n" << message.colorize(:light_magenta)
  end

  conf.logger.level = Logger::DEBUG
end
