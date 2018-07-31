require "granite/adapter/mysql"

Granite::Adapters << Granite::Adapter::Mysql.new({
  name: "mysql",
  url: ENV["DATABASE_URL"]? || Amber.settings.database_url
})

Granite.settings.logger = Amber.settings.logger.dup
Granite.settings.logger.progname = "Granite"
