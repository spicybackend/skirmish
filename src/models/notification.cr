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

  belongs_to :player, Player

  # validate :player, "is required", ->(notification : Notification) do
  #   !Player.find(notification.player_id).nil?
  # end

  # validate :event_type, "is required", ->(notification : Notification) do
  #   (event_type = notification.event_type) ? !event_type.nil? : false
  # end

  # validate :event_type, "must be a valid event type", ->(notification : Notification) do
  #   (event_type = notification.event_type) ? Notification::EVENT_TYPES.includes?(event_type) : false
  # end

  # validate :source, "must match the event type if given", ->(notification : Notification) do
  #   if event_type = notification.event_type
  #     if source_class = SOURCE_CLASS_BY_EVENT_TYPE[event_type]?
  #       # match the class, achieve some messy implementation of polymorphism
  #       (source_type = notification.source_type) ? source_class.name == source_type : false
  #     else
  #       notification.source_type.nil?
  #     end
  #   else
  #     true
  #   end
  # end

  # validate :source, "must exist if given", ->(notification : Notification) do
  #   notification.source_type ? !!notification.source : true
  # end

  # validate :title, "is required", ->(notification : Notification) do
  #   (title = notification.title) ? !title.empty? : false
  # end

  # validate :content, "is required", ->(notification : Notification) do
  #   (content = notification.content) ? !content.empty? : false
  # end

  # def source=(source : Jennifer::Model::Base | Nil)
  #   if source.nil?
  #     self.source_type = nil
  #     self.source_id = nil
  #   else
  #     self.source_type = source.class.name
  #     self.source_id = source.id
  #   end
  # end

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
end
