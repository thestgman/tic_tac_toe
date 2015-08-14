require 'sinatra'
require 'json'

use Rack::Logger
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

options '/something' do
  200
end

get '/something' do
  { result: 'It works'}.to_json
end

post '/something' do
  begin
    params.merge! JSON.parse(request.env['rack.input'].read)
  rescue JSON::ParserError
    logger.error 'Cannot parse request body.'
  end

  { result: params[:something], seen: true }.to_json
end