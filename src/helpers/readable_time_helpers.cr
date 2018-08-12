module ReadableTimeHelpers
  def time_units_since(time : Time | Nil)
    return "-" if time.nil?

    span = Time.now - time

    if span.total_weeks.to_i > 0
      "#{span.total_weeks.to_i} weeks ago"
    elsif span.total_days.to_i > 0
      "#{span.total_days.to_i} days ago"
    elsif span.total_hours.to_i > 0
      "#{span.total_hours.to_i} hours ago"
    elsif span.total_minutes.to_i > 0
      "#{span.total_minutes.to_i} minutes ago"
    elsif span.total_seconds.to_i > 0
      "#{span.total_seconds.to_i} seconds ago"
    else
      "Now"
    end
  end
end
