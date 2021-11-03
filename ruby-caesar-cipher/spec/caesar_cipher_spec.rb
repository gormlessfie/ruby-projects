# frozen_string_literal: true

require './lib/caesar_cipher'

describe '#return_shifted_value' do
  it 'returns a code thats within 0-26' do
    expect(return_shifted_code(100, 26)).to eql(22)
  end

  it 'shift 72' do
    expect(return_shifted_code(72, 26)).to eql(20)
  end
end

describe '#caesar_cipher' do
  it 'a1m3l' do
    expect(caesar_cipher('a1m3l', 3)).to eql('d1p3o')
  end

  it 'z-0a0|' do
    expect(caesar_cipher('z-0a0|', 25)).to eql('y-0z0|')
  end
end

describe '#determine_value' do
  it 'a' do
    expect(determine_value(65, 23)).to eql('X')
  end
  it 'z' do
    expect(determine_value(122, 1)).to eql('a')
  end

  it '!' do
    expect(determine_value('!'.ord, 1)).to eql('!'.ord)
  end
end
