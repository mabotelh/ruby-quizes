require "spec_helper.rb"

describe RomanNumeral do
  subject do
    RomanNumeral.new()
  end

  context "#valid?"
    examples = [
      { input: 'I', expected: true },
      { input: 'V', expected: true },
      { input: 'X', expected: true },
      { input: 'L', expected: true },
      { input: 'C', expected: true },
      { input: 'D', expected: true },
      { input: 'M', expected: true },
      { input: 'II', expected: true },
      { input: 'IV', expected: true },
      { input: 'O', expected: false }
    ]

    examples.each do |example|
      input = example[:input]

      it "should return #{example[:expected].inspect} when #{input} is passed in." do
        expect(subject.valid?(input)).to eql(example[:expected])
      end
    end

    it "should consider lower case characters valid" do
      expect(subject.valid?("i")).to be_true
    end

    it "should not consider special characters like tab to be valid" do 
      expect(subject.valid?("i\t")).to be_false
    end

    it "should not allow invalid characters with valid characters" do
      expect(subject.valid?("io")).to be_false
    end

    it "should allow less than 3 of the same characters" do
      expect(subject.valid?("xxx")).to be_true
    end

    it "should not allow more than 3 of the same characters" do
      expect(subject.valid?("xxxx")).to be_false
    end
    
    it "should allow the same letter to repeat up to 3 times before another letter" do
      expect(subject.valid?("iiiX")).to be_true
    end

    it "should not allow a character to appear more than once unless it is in sequence" do
      expect(subject.valid?("ixi")).to be_false
    end

    it "should only allow I before V or X" do 
      expect(subject.valid?("id")).to be_false
      expect(subject.valid?("iv")).to be_true
      expect(subject.valid?("ix")).to be_true
    end
end
