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
      # Extremely dumb AI.
      available_positions = board.blanks
      strategy = Strategy.new(board, @play_symbol)
      if available_positions.size > 0
        # The order of the strategies is important.
        move_position = strategy.win_position ||
            strategy.block_position ||
            # TODO: forks and more
            available_positions[0]

        board.place_move(move_position, @play_symbol)
      else
        throw 'Error: No more available positions. The game should have ended.'
      end
    end

    # All the public methods in this class return either a position on the board (0-8) or nil
    # if the move can not be made.
    class Strategy
      attr_reader :board, :play_symbol

      def initialize(board, play_symbol)
        @board = board
        # TODO: validate.
        @play_symbol = play_symbol
        @opponent_play_symbol = (TicTacToeApp::Board::ALLOWED_PLAY_SYMBOLS - [@play_symbol])[0]
      end

      # TODO: for some fun, instead of returning the first fit value from the *_position functions
      # could collect all positions which fit the requirement and return one at random.

      def win_position
        [@board.rows, @board.columns, @board.diagonals].each do |winning_collections|
          winning_collections.each do |diagonal|
            position = find_empty_position(diagonal, @play_symbol)
            return position unless position.nil?
          end
        end

        nil
      end

      def block_position
        [@board.rows, @board.columns, @board.diagonals].each do |winning_collections|
          winning_collections.each do |diagonal|
            position = find_empty_position(diagonal, @opponent_play_symbol)
            return position unless position.nil?
          end
        end

        nil
      end

      private

      # Finds an empty position given that the other 2 positions are both filled with play_symbol.
      def find_empty_position(filled_positions, desired_play_symbol)
        actionable_cells = @board.representation.select {|k,_| filled_positions.include?(k)}

        if actionable_cells.values.select {|p| p == desired_play_symbol}.size == 2 &&
            actionable_cells.values.select {|p| p == nil}.size == 1
          # This only works because we already know there is only one element in the hash having a nil value.
          # Invert on a hash 'eats' non-unique values. Could use some refactoring.
          return actionable_cells.invert[nil]
        end

        nil
      end
    end # class Strategy
  end
end