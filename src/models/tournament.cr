class Tournament < Jennifer::Model::Base
  with_timestamps

  mapping(
    id: Primary64,
    league_id: Int64?,
    finished_at: Time?, # get rid of this? can be calculated

    created_at: { type: Time, default: Time.now },
    updated_at: { type: Time, default: Time.now }
  )

  validates_presence :league_id

  belongs_to :league, League
  has_many :matches, Match
  has_many :entrants, Entrant
  has_and_belongs_to_many :players, Player, nil, nil, nil, "entrants", "player_id"

  scope :unfinished { where { _finished_at == nil } }
  scope :for_league { |league| where { _league_id == league.id } }

  def open?
    matches_query.count.zero?
  end

  def in_progress?
    matches_query.exists? && !finished?
  end

  def finished?
    matches_query.exists? && !matches_query.where { _winner_id == nil }.exists?
  end
end
