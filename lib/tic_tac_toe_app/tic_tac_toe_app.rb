#!/usr/bin/env ruby
require 'io/console'

module TicTacToeApp

  # Holds logic related to the game board.
  class Board
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

    # Inserts the play_symbol at position on the field
    def place_move(position, play_symbol)
      # TODO: validate position and play_symbol.

      @field[position] = play_symbol
    end

    def to_s
      "#{@field[0..2].to_s}\n#{@field[3..5].to_s}\n#{@field[6..8].to_s}"
    end
  end


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


  # Contains logic for playing the game
  class Game
    attr_reader :board, :player, :cpu, :winner

    # Create board and players
    def initialize
      @board = Board.new
      @player = Player.new
      @cpu = Computer.new
      @winner = nil
      @is_draw = false
    end

    def play
      until game_ended? do
        puts "\nYour move [0-8]:"
        position = STDIN.getch
        puts position
        player_move(position)

        unless game_ended?
          puts "\nComputer move:"
          cpu_move
        end
      end
    end

    def player_move(position)
      # TODO: find a better way to convert/validate here as "".to_i == 0
      @player.move(@board, position.to_i)
    end

    def cpu_move
      @cpu.move(@board)
    end

    def draw?
      @is_draw
    end

    def game_ended?
      show_board
      if @board.draw?
        @is_draw = true
        puts "\nGame over! DRAW"
        return true
      elsif @board.game_over?
        winner_value = @board.get_winner
        @winner = (winner_value == @player.play_symbol ? 'player' : 'Computer')

        puts "\nGame over! Winner: #{@winner}"
        return true
      end

      false
    end

    def show_board
      puts "\n#{@board.to_s}"
    end
  end
end

game = TicTacToeApp::Game.new
game.play