class Notification < Jennifer::Model::Base
  # notification types
  GENERAL = "general"
  GAME_LOGGED = "game_logged"

  EVENT_TYPES = [
    GENERAL,
    GAME_LOGGED
  ]

  # TODO STI with Jennifer
  SOURCE_CLASS_BY_EVENT_TYPE = {
    GENERAL => nil,
    GAME_LOGGED => Game
  }

  PRESENTER_BY_EVENT_TYPE = {
    GENERAL => Notification::GeneralPresenter,
    GAME_LOGGED => Notification::LoggedGamePresenter
  }

  with_timestamps

  mapping(
    id: { type: Int64, primary: true },
    player_id: Int64?,
    source_type: String?,
    source_id: Int64?,

    title: String,
    content: String,
    event_type: String,

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
  validates_presence :event_type
  validates_presence :sent_at

  validates_inclusion :event_type, in: EVENT_TYPES

  validates_with PlayerRelationValidator
  validates_with_method :source_present_and_valid

  def source_present_and_valid
    source_class = SOURCE_CLASS_BY_EVENT_TYPE[event_type]?

    if source_class
      if source_type != source_class.name
        errors.add(:source_type, "must be a #{source_class.name}")
      elsif source_class.find(source_id).nil?
        errors.add(:source, "must exist")
      end
    elsif source_type
      errors.add(:source, "must be nil for #{event_type} notifications")
    end

    return unless source_id || source_type

    if source_id.nil? || source_type.nil?
      if source_id
        errors.add(:source_type, "must also be present if source_id is given")
      else
        errors.add(:source_id, "must also be present if source_type is given")
      end
    end
  end
  def source
    if source_class = SOURCE_CLASS_BY_EVENT_TYPE[event_type]?
      source_class.find(source_id)
    end
  end

  def presented
    PRESENTER_BY_EVENT_TYPE[event_type].new(self)
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
