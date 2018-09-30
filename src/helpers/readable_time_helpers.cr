module ReadableTimeHelpers
  def time_units_since(time : Time | Nil)
    return "-" if time.nil?

    span = Time.now - time

    if span.total_weeks.to_i > 0
      if span.total_weeks.to_i == 1
        "Last week"
      else
        "#{span.total_weeks.to_i} weeks ago"
      end
    elsif span.total_days.to_i > 0
      if span.total_days.to_i == 1
        "Yesterday"
      else
        "#{span.total_days.to_i} days ago"
      end
    elsif span.total_hours.to_i > 0
      if span.total_hours.to_i == 1
        "An hour ago"
      else
        "#{span.total_hours.to_i} hours ago"
      end
    elsif span.total_minutes.to_i > 0
      if span.total_minutes.to_i == 1
        "A minute ago"
      else
        "#{span.total_minutes.to_i} minutes ago"
      end
    elsif span.total_seconds.to_i > 0
      if span.total_seconds.to_i == 1
        "A second ago"
      else
        "#{span.total_seconds.to_i} seconds ago"
      end
    else
      "Now"
    end
  end
end
