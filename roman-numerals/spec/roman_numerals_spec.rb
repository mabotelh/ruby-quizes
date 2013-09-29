require "spec_helper.rb"
require "pry"

describe RomanLetter do
  context "#from_string" do
    examples = [
      { input: 'I', expected: RomanI },
      { input: 'V', expected: RomanV },
      { input: 'X', expected: RomanX },
      { input: 'L', expected: RomanL },
      { input: 'C', expected: RomanC },
      { input: 'D', expected: RomanD },
      { input: 'M', expected: RomanM }
    ]

    examples.each do |example|
      input = example[:input]

      it "should return #{example[:expected].inspect} when #{input} is passed in." do
        expect(RomanLetter.from_string(input)).to be_kind_of(example[:expected])
      end
    end

    examples = [
      {input: 'I', expected: 1},
      {input: 'II', expected: 2},
      {input: 'III', expected: 3},
      {input: 'iV', expected: 4},
      {input: 'V', expected: 5},
      {input: 'VI', expected: 6},
      {input: 'VII', expected: 7},
      {input: 'IIIX', expected: 7},
      {input: 'VIII', expected: 8},
      {input: 'IIX', expected: 8},
      {input: 'IX', expected: 9},
      {input: 'X', expected: 10},
      {input: 'XIX', expected: 19},
      {input: 'MMMIM', expected: 3999},
      {input: 'XM', expected: 990}
    ]

    examples.each do |example|
      input = example[:input]
      expected = example[:expected]
      it "should return #{expected} when #{input} is passed in." do
        expect(RomanLetter.from_string(input).to_i).to eq(expected)
      end
    end
    it "should raise Invalid String when an invalid character is passed in" do
      expect{RomanLetter.from_string("O")}.to raise_error("Invalid String")
    end

    it "should set the signal to negative if the value of the character to the right is higher than self's" do
      expect(RomanI.new(RomanX.new(nil)).decimal_signal).to eq(-1)
    end

    it "should set the signal to positive if the value of the character to the right is the same as self" do
      expect(RomanI.new(RomanI.new(nil)).decimal_signal).to eq(1)
    end

    it "should set the signal to the same of the next if it is a repetition" do
      expect(RomanI.new(RomanI.new(RomanX.new(nil))).decimal_signal).to eq(-1)
    end

    it "should allow up to three of the same characters and no more" do
      expect{RomanI.new(RomanI.new(RomanI.new(RomanI.new(nil))))}.to raise_error("Too many repetitions of I.")
    end

    it "should not allow repetitions of V, L, D" do
      #expect{RomanV.new(RomanV.new(nil))}.to raise_error("Repetition of V is not allowed")
      ii = RomanLetter.I.I
      binding.pry
      expect{RomanV.new(RomanV.new(nil))}.to raise_error("Repetition of V is not allowed")
      expect{RomanL.new(RomanL.new(nil))}.to raise_error("Repetition of L is not allowed")
      expect{RomanD.new(RomanD.new(nil))}.to raise_error("Repetition of D is not allowed")
    end
  end
end

describe RomanI do
  subject do
    RomanI.new(nil)
  end

  it "should have a value of 1" do
    expect(subject.value).to eql(1)
  end
  
  it "should have a letter of I" do
    expect(subject.letter).to eql("I")
  end

  it "should work without anything to the right" do
    expect(subject.valid?).to be_true
  end

  it "should not allow anything other than X or V to the right" do
    x = RomanI.new(RomanX.new(nil))
    expect(x.valid?).to be_true

    v = RomanI.new(RomanV.new(nil))
    expect(v.valid?).to be_true

    l = RomanI.new(RomanL.new(nil))
    expect(l.valid?).to be_false
  end
end
