require "granite/adapter/pg"

Granite::Adapters << Granite::Adapter::Pg.new({
  name: "postgres",
  url: ENV["DATABASE_URL"]? || Amber.settings.database_url
})

# Avoiding accessing Amber.settings in production for the time being due to encryption being broken in crystal...
Granite.settings.logger = Amber.env.production? ? Logger.new(STDOUT) : Amber.settings.logger.dup
Granite.settings.logger.progname = "Granite"
