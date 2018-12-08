class CreateInvitations < Jennifer::Migration::Base
  def up
    create_table(:invitations) do |t|
      t.bigint :id, { :primary => true, :auto_increment => true }

      t.bigint("league_id")
      t.bigint("player_id")
      t.bigint("approver_id")
      t.timestamp("accepted_at")
      t.timestamp("approved_at")

      t.timestamps
    end
  end

  def down
    drop_table(:invitations)
  end
end
