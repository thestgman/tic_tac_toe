#!/usr/bin/env ruby
require 'io/console'
require_relative './board'
require_relative 'player'
require_relative 'computer'

module TicTacToeApp
  # Contains logic for playing the game.
  class Game
    attr_reader :board, :player, :cpu, :winner

    # Create board and players.
    def initialize
      @board = Board.new
      @player = Player.new
      @cpu = Computer.new
      @winner = nil
      @is_draw = false
    end

    # TODO: this is only used for testing (running in the console). It should be removed once
    # unit tests exist.
    def play
      until game_ended? do
        puts "\nYour move [0-8]:"
        position = STDIN.getch
        puts position
        # TODO: find a better way to convert/validate here as "".to_i == 0
        player_move(position.to_i)

        unless game_ended?
          puts "\nComputer move:"
          cpu_move
        end
      end
    end

    def player_move(position)
      @player.move(@board, position)
    end

    def cpu_move
      @cpu.move(@board)
    end

    # TODO: this is only used for testing (running in the console). It should be removed once
    # unit tests exist.
    def draw?
      @is_draw
    end

    # TODO: this is only used for testing (running in the console). It should be removed once
    # unit tests exist.
    def game_ended?
      show_board
      if @board.draw?
        @is_draw = true
        puts "\nGame over! DRAW"
        return true
      elsif @board.game_over?
        winner_value = @board.get_winner
        @winner = (winner_value == @player.play_symbol ? 'Player' : 'Computer')

        puts "\nGame over! Winner: #{@winner}!"
        return true
      end

      false
    end

    # TODO: this is only used for testing (running in the console). It should be removed once
    # unit tests exist.
    def show_board
      puts "\n#{@board.to_s}"
    end
  end
end