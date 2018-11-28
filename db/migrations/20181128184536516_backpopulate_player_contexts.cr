class BackpopulatePlayerContexts < Jennifer::Migration::Base
  def up
    exec("
      INSERT INTO player_contexts(player_id, created_at, updated_at)
      SELECT id, now(), now()
      FROM players
    ")
  end

  def down
    exec("
      TRUNCATE TABLE player_contexts
    ")
  end
end
