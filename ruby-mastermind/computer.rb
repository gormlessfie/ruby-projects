# frozen_string_literal: true

require './player'

# A computer class that will follow a basic strategy for winning
class Computer < Player
  def initialize
    super
  end

  def assign_secret_codes
    4.times { @secret_code.push(Peg.new(POSSIBLE_COLORS.sample)) }
  end

  def assign_guess_codes
    4.times { @guess.push(Peg.new(POSSIBLE_COLORS.sample)) }
  end
end
