require "granite/adapter/pg"

MAX_POOL_SIZE = 5

database_url = ENV["DATABASE_URL"]? || Amber.settings.database_url
database_connection_params = {
  max_pool_size: MAX_POOL_SIZE
}

database_params = "?" + database_connection_params.map do |key, value|
  "#{key}=#{value}"
end.join("&")

Granite::Adapters << Granite::Adapter::Pg.new({
  name: "postgres",
  url: "#{database_url}#{database_params}"
})

# Avoiding accessing Amber.settings in production for the time being due to encryption being broken in crystal...
Granite.settings.logger = Amber.env.production? ? Logger.new(STDOUT) : Amber.settings.logger.dup
Granite.settings.logger.progname = "Granite"
