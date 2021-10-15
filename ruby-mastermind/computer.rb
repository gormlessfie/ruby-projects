# frozen_string_literal: true

require './player'

# A computer class that will follow a basic strategy for winning
class Computer < Player
  def initialize(name)
    super
    @name = name
  end

  def assign_secret_codes
    4.times { @secret_code.push(Peg.new(POSSIBLE_COLORS.sample)) }
  end
end
