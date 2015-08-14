#!/usr/bin/env ruby

module TicTacToeApp
  # Holds logic related to the game board.
  class Board
    # TODO: move this into an util?
    ALLOWED_PLAY_SYMBOLS = %w(x o)

    attr_accessor :representation

    def initialize
      # The keys are the positions on the board and the values are one of the
      # play_symbols or nil.
      @representation = Hash[(0..8).collect {|v| [v, nil]}]
    end

    def field
      @representation.values
    end

    def positions
      @representation.keys
    end

    def rows
      positions.each_slice(3).to_a
    end

    def columns
      rows.transpose
    end

    def diagonals
      diagonals = []
      diagonals << 3.times.map {|i| positions[i * 4]}
      diagonals << 3.times.map {|i| positions[2 + i * 2]}

      diagonals
    end

    # Returns all blank positions on the field.
    def blanks
      field.each_with_index.map {|v, i| i if v == nil}.reject{|v| v.nil?}
    end

    def board_full?
      !field.any?{|v| v.nil?}
    end

    # Returns either the winning value from {'x', 'o'} if the game has
    # ended and it's not a draw or nil otherwise.
    def get_winner
      # TODO: maybe store the winner in a var.
      [rows, columns, diagonals].each {|item|
        item.each {|positions|
          values = positions.map {|position| field[position]}
          return values[0] if (!values[0].nil? && values.uniq.length == 1)
        }
      }

      nil
    end

    def draw?
      board_full? && get_winner.nil?
    end

    def game_over?
      draw? || !get_winner.nil?
    end

    # Inserts the play_symbol at position on the field.
    def place_move(position, play_symbol)
      validate_value(play_symbol)
      validate_position(position)

      @representation[position] = play_symbol
    end

    def undo_move(position)
      validate_position(position, true)
      @representation[position] = nil
    end

    def to_s
      "#{field[0..2].to_s}\n#{field[3..5].to_s}\n#{field[6..8].to_s}"
    end

    private

    def validate_value(play_symbol)
      unless ALLOWED_PLAY_SYMBOLS.include?(play_symbol)
        throw "Illegal value: [#{value}]. Allowed values are #{ALLOWED_PLAY_SYMBOLS}"
      end
    end

    def validate_position(position, skip_filled_check=false)
      unless positions.include?(position)
        throw "Illegal position: [#{position}]. Valid values: #{positions}"
      end

      unless skip_filled_check || blanks.include?(position)
        throw "Illegal position: [#{position}]. Already filled with [#{field[position]}]"
      end
    end
  end
end