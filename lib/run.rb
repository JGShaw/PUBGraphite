require 'rubg'
require 'socket'
require_relative 'metric_extractor'

api_key = ARGV[0].dup
graphite_ip = ARGV[1]
graphite_port = ARGV[2]
shard = ARGV[3].dup
player_names = ARGV[4].dup

extractor = MetricExtractor.new(api_key)
players = extractor.players(shard, player_names)

loop do

  metrics = []

  players.each do |player|
    metrics.concat extractor.extract(shard, player)
  end

  socket = TCPSocket.new(graphite_ip, graphite_port)
  metrics.each do |metric|
    socket.puts metric
  end
  socket.close

  sleep 120
end
