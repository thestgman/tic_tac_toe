#!/usr/bin/env ruby
require_relative 'board'

module TicTacToeApp
  # Encapsulates the human player logic.
  class Player
    attr_reader :play_symbol

    def initialize
      @play_symbol = 'x'
    end

    # Given the board, tick on the specified position.
    def move(board, position)
      board.place_move(position, @play_symbol)
    end
  end
end