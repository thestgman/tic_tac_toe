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
            strategy.fork_position ||
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

      def win_positions(board)
        positions = []
        [board.rows, board.columns, board.diagonals].each do |winning_collections|
          winning_collections.each do |collection|
            position = find_empty_position(collection, @play_symbol)
            positions << position unless position.nil?
          end
        end

        positions
      end

      def win_position
        random_position(win_positions(@board))
      end

      def block_positions(board)
        positions = []
        [board.rows, board.columns, board.diagonals].each do |block_collections|
          block_collections.each do |collection|
            position = find_empty_position(collection, @opponent_play_symbol)
            positions << position unless position.nil?
          end
        end

        positions
      end

      def block_position
        random_position(block_positions(@board))
      end

      # Fill each blank and if there's more than two winning positions than we have a fork.
      def fork_positions
        board = @board.clone
        positions = []

        board.blanks.each do |blank_position|
          board.place_move(blank_position, @play_symbol)

          if win_positions(board).size >= 2
            positions << blank_position
          end

          board.undo_move(blank_position)
        end

        positions
      end

      def fork_position
        random_position(fork_positions)
      end

      private

      def random_position(positions)
        positions.empty? ? nil : positions.sample
      end

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