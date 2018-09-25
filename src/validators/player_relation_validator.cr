class PlayerRelationValidator < Jennifer::Validator
  def validate(subject)
    if Player.find(subject.player_id).nil?
      errors.add(:player, "must exist")
    end
  end
end
