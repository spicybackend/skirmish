require "granite/adapter/mysql"

Granite::Adapters << Granite::Adapter::Mysql.new({
  name: "mysql",
  url: ENV["DATABASE_URL"]? || Amber.settings.database_url
})

# Avoiding accessing Amber.settings in production for the time being due to encryption being broken in crystal...
Granite.settings.logger = Amber.env.production? ? Logger.new(STDOUT) : Amber.settings.logger.dup
Granite.settings.logger.progname = "Granite"
