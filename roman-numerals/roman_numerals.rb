require "pry"

class RomanNumeral
  ROMANS = ['I', 'V', 'X', 'L', 'C', 'D', 'M']

  def valid? numeral
    used = Hash[ROMANS.collect { |v| [v,0] }]
    valid = true
    last_char = ''
    numeral.each_char do |n|
      n = n.upcase
      if used.key?(n)
        used[n] = used[n] + 1 
        valid = valid && used[n] < 4
        #p "last_char: #{last_char} valid: #{valid} used[#{n}]: #{used[n]} #{last_char !=n} #{used[n] == 1 }"
        valid = valid && used[n] == 1 if last_char != n
      #p "valid?: #{valid}"
        last_char = n
      else
        valid = false
      end
    end
      #p "valid?: #{valid}"
    valid #&& char_count < 4
  end
end

class RomanLetter
  include Comparable

  attr_reader :value
  attr_reader :letter
  attr_reader :decimal_sign
  attr_accessor :previous
  attr_accessor :succ
  attr_accessor :repeat_count

  ROMANS = ['I', 'V', 'X', 'L', 'C', 'D', 'M']

  def initialize(succ)
    @succ = succ
    @repeat_count = self.eql?(succ) ? succ.repeat_count + 1 : 1
    succ.previous = self if succ
    raise "Too many repetitions of #{@letter}." if repeat_count > 3 
    raise "Repetition of #{letter} is not allowed" if repeat_count > 1 && ((succ.kind_of? RomanV) || (succ.kind_of? RomanL) || (succ.kind_of? RomanD))
  end

  def self.from_string(string)
    up_string = string.upcase.reverse
    rv = nil
    up_string.each_char do |c|
      if ROMANS.include? c
        clazz = Object.const_get("Roman" + c)
        rv = clazz.new(rv)
      else
        raise "Invalid String"
      end
    end
    rv
  end

  def I
    return RomanI.new(self)
  end

  def self.I
    return RomanI.new(nil)
  end

  def <=>(another_letter)
    self.value <=> another_letter.value
  end

  def decimal_signal
    rv = 1
    if @succ
      rv = self.value == @succ.value ? @succ.decimal_signal : self <=> @succ
    end
    rv
  end

  def to_i
    decimal_signal * value + (succ ? succ.to_i : 0)
  end

  def eql? other
    other ? other.letter == self.letter : false
  end
end

class RomanI < RomanLetter
  def initialize(succ)
    @letter = "I"
    @value = 1
    super(succ)
  end

  def valid?
    (@succ.nil?) || (@succ.kind_of? RomanV) || (@succ.kind_of? RomanX)
  end
end

class RomanV < RomanLetter
  def initialize(succ)
    @letter = "V"
    @value = 5
    super(succ)
  end
end

class RomanX < RomanLetter
  def initialize(succ)
    @letter = "X"
    @value = 10
    super(succ)
  end
end

class RomanL < RomanLetter
  def initialize(succ)
    @letter = "L"
    @value = 50
    super(succ)
  end
end

class RomanC < RomanLetter
  def initialize(succ)
    @letter = "C"
    @value = 100
    super(succ)
  end
end

class RomanD < RomanLetter
  def initialize(succ)
    @letter = "D"
    @value = 500
    super(succ)
  end
end

class RomanM < RomanLetter
  def initialize(succ)
    @letter = "M"
    @value = 1000
    super(succ)
  end
end
