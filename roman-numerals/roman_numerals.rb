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
        p "last_char: #{last_char} valid: #{valid} used[#{n}]: #{used[n]} #{last_char !=n} #{used[n] == 1 }"
        valid = valid && used[n] == 1 if last_char != n
      p "valid?: #{valid}"
        last_char = n
      else
        valid = false
      end
    end
      p "valid?: #{valid}"
    valid #&& char_count < 4
  end
end

class RomanLetter
  ROMANS = ['I', 'V', 'X', 'L', 'C', 'D', 'M']
  def new(letter, previous)
    @next_letter = nil
    @previous = previous
    @previous.next = self
  end
end

class RomanI < RomanLetter
  @letter = "I"
  @value = 1

  def valid?
    @previous.nil? || @previous.kind_of? RomanV || @previous.kind_of? RomanX
  end
end

class RomanV < RomanLetter
end

class RomanX < RomanLetter
end
