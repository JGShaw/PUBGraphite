# frozen_string_literal: true

require 'rubg'
require 'socket'
require_relative 'metric_extractor'

api_key = ARGV[0].dup
graphite_ip = ARGV[1]
graphite_port = ARGV[2]
shard = ARGV[3].dup
player_names = ARGV[4].dup

past_matches = {}

rubg_client = RUBG.new(api_key: api_key)

loop do
  matches = {}
  metrics = []

  players_response = rubg_client.players(shard: shard, query_params: { player_names: player_names })
  players_response.players.each do |player|
    latest_match_id = player.match_ids.first

    next if past_matches[player.name] == latest_match_id
    if !matches.key?(latest_match_id)
      latest_match = rubg_client.match(shard: shard, query_params: { match_id: latest_match_id })
      matches[latest_match_id] = latest_match
    else
      latest_match = matches[latest_match_id]
    end
    past_matches[player.name] = latest_match.match_id

    # Process the latest match
    participant = latest_match.participants.select { |participant| participant.player_id == player.player_id }.first

    metrics = MetricExtractor.extract(player, participant, latest_match)
  end

  puts metrics

  socket = TCPSocket.new(graphite_ip, graphite_port)
  metrics.each do |metric|
    socket.puts metric
  end
  socket.close

  sleep 120
end
