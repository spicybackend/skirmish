class AddLeagueIdToAdministrators < Jennifer::Migration::Base
  def up
    exec("ALTER TABLE administrators ADD COLUMN league_id BIGSERIAL NOT NULL REFERENCES leagues(id) ON DELETE CASCADE;")
  end

  def down
    exec("ALTER TABLE administrators DROP COLUMN league_id;")
  end
end
