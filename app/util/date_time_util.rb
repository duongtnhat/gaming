# frozen_string_literal: true

module DateTimeUtil
  def self.start_of unit, time
    case unit
    when :minute
      Time.new(time.year, time.month, time.day, time.hour, time.min)
    when :hour
      Time.new(time.year, time.month, time.day, time.hour)
    when :day
      Time.new(time.year, time.month, time.day)
    when :month
      Time.new(time.year, time.month)
    when :year
      Time.new(time.year)
    else
      return time
    end
  end
end
