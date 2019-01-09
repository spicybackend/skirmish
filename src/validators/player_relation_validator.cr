class PlayerRelationValidator < Jennifer::Validations::Validator
  def validate(subject)
    if Player.find(subject.player_id).nil?
      subject.errors.add(:player, "must exist")
    end
  end
end
