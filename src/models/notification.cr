class Notification < Granite::Base
  adapter postgres
  table_name notifications

  belongs_to :player

  field event_type : String
  field title : String
  field content : String
  field source_type : String
  field source_id : Int64
  field sent_at : Time
  field read_at : Time
  timestamps

  # notification types
  GENERAL = "general"
  GAME_LOGGED = "game_logged"

  EVENT_TYPES = [
    GENERAL,
    GAME_LOGGED
  ]

  SOURCE_CLASS_BY_EVENT_TYPE = {
    GENERAL => nil,
    GAME_LOGGED => Game
  }

  validate :player, "is required", ->(notification : Notification) do
    !Player.find(notification.player_id).nil?
  end

  validate :event_type, "is required", ->(notification : Notification) do
    (event_type = notification.event_type) ? !event_type.nil? : false
  end

  validate :event_type, "must be a valid event type", ->(notification : Notification) do
    (event_type = notification.event_type) ? Notification::EVENT_TYPES.includes?(event_type) : false
  end

  validate :source, "must match the event type if given", ->(notification : Notification) do
    if event_type = notification.event_type
      if source_class = SOURCE_CLASS_BY_EVENT_TYPE[event_type]?
        # match the class, achieve some messy implementation of polymorphism
        (source_type = notification.source_type) ? source_class.name == source_type : false
      else
        notification.source_type.nil?
      end
    else
      true
    end
  end

  validate :source, "must exist if given", ->(notification : Notification) do
    notification.source_type ? !!notification.source : true
  end

  validate :title, "is required", ->(notification : Notification) do
    (title = notification.title) ? !title.empty? : false
  end

  validate :content, "is required", ->(notification : Notification) do
    (content = notification.content) ? !content.empty? : false
  end

  def source=(source : Granite::Base | Nil)
    if source.nil?
      self.source_type = nil
      self.source_id = nil
    else
      self.source_type = source.class.name
      self.source_id = source.id
    end
  end

  def source
    if source_class = SOURCE_CLASS_BY_EVENT_TYPE[event_type]?
      source_class.find(source_id)
    end
  end

  def read?
    !!read_at
  end
end
