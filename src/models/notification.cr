class Notification < Jennifer::Model::Base
  with_timestamps

  mapping(
    id: Primary64,
    player_id: Int64?,

    title: String,
    content: String,
    type: String?,

    sent_at: { type: Time, default: Time.now },
    read_at: Time?,

    created_at: { type: Time, default: Time.now },
    updated_at: { type: Time, default: Time.now }
  )

  scope :read { where { _read_at != nil } }
  scope :unread { where { _read_at == nil } }
  scope :for_player { |player| where { _player_id == player.id } }

  belongs_to :player, Player

  validates_presence :player_id
  validates_presence :title
  validates_presence :content
  validates_presence :sent_at

  validates_with PlayerRelationValidator

  def action_url
    "/notifications"
  end

  def read?
    !!read_at
  end

  def read!
    return if read?

    self.read_at = Time.now
    save!
  end
end
