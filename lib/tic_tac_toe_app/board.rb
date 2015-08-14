#!/usr/bin/env ruby

module TicTacToeApp
  # Holds logic related to the game board.
  class Board
    ALLOWED_PLAY_SYMBOLS = %w(x o)

    def initialize
      @field = [nil, nil, nil, nil, nil, nil, nil, nil, nil]
      @cells = @field.each_with_index.map {|_, i| i}
      @rows = @cells.each_slice(3).to_a
      @columns = @rows.transpose
      @diagonals = []
      @diagonals << 3.times.map {|i| @cells[i * 4]}
      @diagonals << 3.times.map {|i| @cells[2 + i * 2]}
    end

    # Returns all blank positions on the field.
    def blanks
      @field.each_with_index.map {|v, i| i if v == nil}.reject{|v| v.nil?}
    end

    def board_full?
      !@field.any?{|v| v.nil?}
    end

    # Returns either the winning value from {'x', 'o'} if the game has
    # ended and it's not a draw or nil otherwise.
    def get_winner
      # TODO: maybe store the winner in a var.

      [@rows, @columns, @diagonals].each {|item|
        item.each {|positions|
          values = positions.map {|position| @field[position]}
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

      @field[position] = play_symbol
    end

    def to_s
      "#{@field[0..2].to_s}\n#{@field[3..5].to_s}\n#{@field[6..8].to_s}"
    end

    private

    def validate_value(play_symbol)
      unless ALLOWED_PLAY_SYMBOLS.include?(play_symbol)
        throw "Illegal value: [#{value}]. Allowed values are #{ALLOWED_PLAY_SYMBOLS}"
      end
    end

    def validate_position(position)
      unless blanks.include?(position)
        throw "Illegal position: [#{position}]. Already filled with [#{@field[position]}]"
      end
    end
  end
end