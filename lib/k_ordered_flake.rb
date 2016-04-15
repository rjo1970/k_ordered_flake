require "concurrent"
require "k_ordered_flake/version"
require "k_ordered_flake/exceptions"
require "date"
require "macaddr"
require "digest"

module KOrderedFlake

  def self.epoc
    DateTime.now.strftime('%Q').to_i
  end

  def self.identity
    mac = Mac.address.split(':').join('')
    code = Digest::SHA1.hexdigest(mac)[28..-1]
    code.to_i(16)
  end

  STATE = Concurrent::Atom.new({
    time: self.epoc,
    identity: self.identity,
    counter: 0 })

  DIGITS = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a

  def self.to_base_62(x)
    result = []
    while x > 61
      y = x % 62
      x /= 62
      result.unshift self::DIGITS[y]
    end
    result.unshift self::DIGITS[x]
    result.join ""
  end

  def self.clock(state, time)
    s = state.clone
    if (time == s[:time])
      s[:counter] = (s[:counter] + 1) % 65536
      raise KOrderedFlake::CounterOverflowException.new("Too many increments per millisecond") if s[:counter] == 0
    elsif time > s[:time]
      s[:counter] = 0
      s[:time] = time
    else
      raise KOrderedFlake::TimeDiscontinuityException.new("Time may not run backwards #{state[:time]} > #{time}")
    end
    s
  end

  def self.encode(state)
    x = (state[:time] << 64) + (state[:identity] << 16) + state[:counter]
    self.to_base_62(x)
  end

  def self.flake
    t = self.epoc
    sample = self::STATE.swap(t) { |s, t| self.clock(s, t) }
    self.encode(sample)
  end

end
