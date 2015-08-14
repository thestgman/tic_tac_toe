require 'sinatra'
require 'json'
require './lib/tic_tac_toe_app/game'

use Rack::Logger

# TODO: using global variables is just awful! There must be a better way of keeping state!
$game = nil
$winner = nil
$draw = nil

before do
  content_type :json
  headers 'Access-Control-Allow-Origin' => '*',
          'Access-Control-Allow-Methods' => %w(OPTIONS GET POST),
          'Access-Control-Allow-Headers' => 'Content-Type'
end

set :protection, false

get '/new_game' do
  $game = TicTacToeApp::Game.new
  $winner = nil
  $draw = nil

  { field: $game.board.field }.to_json
end

options '/do_move' do
  200
end

post '/do_move' do
  begin
    params.merge! JSON.parse(request.env['rack.input'].read)
  rescue JSON::ParserError
    logger.error 'Cannot parse request body.'
  end

  $game.player_move params[:position]
  unless game_ended?
    $game.cpu_move
  end
  game_ended?

  { field: $game.board.field, winner: $winner, draw: $draw }.to_json
end

def game_ended?
  if $game.game_ended?
    if $game.draw?
      $draw = $game.draw?
    else
      $winner = $game.winner
    end
  end

  $game.game_ended?
end