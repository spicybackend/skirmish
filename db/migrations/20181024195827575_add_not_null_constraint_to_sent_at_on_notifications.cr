class AddNotNullConstraintToSentAtOnNotifications < Jennifer::Migration::Base
  def up
    exec("ALTER TABLE notifications ALTER COLUMN sent_at SET DEFAULT now();")
    exec("ALTER TABLE notifications ALTER COLUMN sent_at SET NOT NULL")
  end

  def down
    exec("ALTER TABLE notifications ALTER COLUMN sent_at DROP NOT NULL")

    # This is the reverse, but I'd rather not actually break the data on reverse when only some rows are affected
    # exec("ALTER TABLE notifications ALTER COLUMN sent_at SET DEFAULT NULL")
  end
end
