class Notification < Granite::Base
  adapter postgres
  table_name notifications

  belongs_to :player

  field event_type : String
  field sent_at : Time
  field read_at : Time
  field title : String
  field content : String
  timestamps

  # notification types
  GENERAL = "general"

  EVENT_TYPES = [
    GENERAL
  ]

  validate :player, "is required", ->(notification : Notification) do
    !Player.find(notification.player_id).nil?
  end

  validate :event_type, "is required", ->(notification : Notification) do
    (event_type = notification.event_type) ? !event_type.nil? : false
  end

  validate :event_type, "must be a valid event type", ->(notification : Notification) do
    (event_type = notification.event_type) ? Notification::EVENT_TYPES.includes?(event_type) : false
  end

  validate :title, "is required", ->(notification : Notification) do
    (title = notification.title) ? !title.empty? : false
  end

  validate :content, "is required", ->(notification : Notification) do
    (content = notification.content) ? !content.empty? : false
  end

  def read?
    !!read_at
  end
end
