class PlayerTagValidator < Jennifer::Validator
  def validate(subject)
    unless subject.tag.match(/^[a-zA-Z]+[a-zA-Z0-9_.-]*$/)
      errors.add(:tag, "must start with a letter and can only include letters, numbers, or symbols")
    end
  end
end
