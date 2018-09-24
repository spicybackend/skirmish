class LeagueRelationValidator < Jennifer::Validator
  def validate(subject)
    if League.find(subject.league_id).nil?
      errors.add(:league, "must exist")
    end
  end
end
