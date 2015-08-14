#!/usr/bin/env ruby

module TicTacToeApp

  # Holds logic related to the game board.
  class Board
    def initialize
      @field = [nil, nil, nil, nil, nil, nil, nil, nil, nil]
      @cells = @field.each_with_index.map {|_, i| i}

      # TODO: identify rows, columns, diagonals
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
      nil
    end

    def draw?
      board_full? && get_winner.nil?
    end

    def game_over?
      draw? || !get_winner.nil?
    end

    # Inserts the play_symbol at position on the field
    def place_move(position, play_symbol)
      nil
    end

    def to_s
      "#{field[0..2].to_s}\n#{field[3..5].to_s}\n#{field[6..8].to_s}"
    end
  end


  # Encapsulates the human player logic.
  class Player
    # Given the board, tick on the specified position.
    def move
      # TODO: implement.
    end
  end


  # Encapsulates the computer logic (AI?).
  class Computer
    def move
      # TODO: implement.
    end
  end


  # Contains logic for playing the game
  class Game
    attr_reader :board, :player, :cpu, :winner

    # Create board and players
    def initialize
      @board = Board.new
      @player = Player.new
      @cpu = Computer.new
      @winner = nil
    end

    def play
      until game_ended? do
        # PLAY!
      end
    end

    def player_move(position)
    end

    def cpu_move
    end

    def game_ended?
      true
    end

    def show_board
      puts "\n#{@board.to_s}"
    end
  end
end

game = TicTacToeApp::Game.new
game.play