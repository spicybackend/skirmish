class LeagueRelationValidator < Jennifer::Validations::Validator
  def validate(subject)
    if League.find(subject.league_id).nil?
      subject.errors.add(:league, "must exist")
    end
  end
end
