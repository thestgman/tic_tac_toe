#!/usr/bin/env ruby
require_relative 'board'

module TicTacToeApp
  # Encapsulates the computer logic (AI?).
  class Computer
    attr_reader :play_symbol

    def initialize
      @play_symbol = 'o'
    end

    def move(board)
      # TODO: smarten up Computer. The extremely dumb AI just picks the first blank position on the board.
      available_positions = board.blanks
      if available_positions.size > 0
        board.place_move(available_positions[0], @play_symbol)
      else
        throw 'Error: No more available positions. The game should have ended.'
      end
    end
  end
end