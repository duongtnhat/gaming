# frozen_string_literal: true

module RandomUtil
  def self.random range, number, duplicate
    res = []
    number.times do
      while true do
        next_num = rand(range)
        break if duplicate
        break if res.exclude?(next_num)
      end
      res << next_num
    end
    res.sort!
  end
end
