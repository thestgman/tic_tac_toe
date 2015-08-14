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
      available_positions = board.blanks
      strategy = Strategy.new(board, @play_symbol)
      if available_positions.size > 0
        # The order of the strategies is important. In theory it should never get to use the
        # last one (random_empty_position).
        move_position = strategy.win_position ||
            strategy.block_position ||
            strategy.fork_position ||
            strategy.block_fork_position ||
            strategy.center_position ||
            strategy.opposite_corner ||
            strategy.empty_corner ||
            strategy.empty_side ||
            strategy.random_empty_position

        board.place_move(move_position, @play_symbol)
      else
        throw 'Error: No more available positions. The game should have ended.'
      end
    end

    # All the public methods in this class return either a position on the board (0-8) or nil
    # if the move can not be made.
    #
    # For an invulnerable AI the minimax algorithm seems to do the job, but I decided to
    # go for my own implementation given the short period of implementation time.
    class Strategy
      def initialize(board, play_symbol)
        @board = board
        # TODO: validate.
        @play_symbol = play_symbol
        @opponent_play_symbol = (TicTacToeApp::Board::ALLOWED_PLAY_SYMBOLS - [@play_symbol])[0]
      end

      def win_position
        random_position(win_positions(@board))
      end

      def block_position
        random_position(block_positions(@board))
      end

      def fork_position
        random_position(fork_positions)
      end

      def block_fork_position
        random_position(block_fork_positions)
      end

      def center_position
        @board.blanks.include?(4) ? 4 : nil
      end

      def opposite_corner
        random_position(opposite_corners)
      end

      def empty_corner
        random_position(empty_corners)
      end

      def empty_side
        random_position(empty_sides)
      end

      def random_empty_position
        random_position(@board.blanks)
      end

      private

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

      # Fill each blank and if there's more than two blocking positions than we have a fork block.
      def block_fork_positions
        board = @board.clone
        positions = []

        board.blanks.each do |blank_position|
          board.place_move(blank_position, @play_symbol)

          if block_positions(board).size >= 2
            positions << blank_position
          end

          board.undo_move(blank_position)
        end

        positions
      end

      def valid_corner_positions(corner_positions)
        positions = []

        corner_positions.each do |corner_coordinates|
          if @board.field[corner_coordinates[0]] == @opponent_play_symbol &&
              @board.field[corner_coordinates[1]].nil?
            positions << corner_coordinates[1]
          end
        end

        positions
      end

      def opposite_corners
        positions = []
        # TODO: swap values programatically.
        positions += valid_corner_positions([[0, 7], [2, 5]])
        positions += valid_corner_positions([[7, 0], [5, 2]])

        positions
      end

      def empty_corners
        @board.blanks & [0, 2, 6, 8]
      end

      def empty_sides
        @board.blanks & [1, 3, 5, 7]
      end

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