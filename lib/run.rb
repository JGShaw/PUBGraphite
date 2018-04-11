require 'rubg'
require 'socket'

def match_metric(participant, stat_name, stat, time)
  "PUBG.#{ participant.name }.matches.#{ stat_name } #{ stat } #{ time }"
end

api_key = ARGV[0]
shard = "pc-eu"

past_matches = {}

rubg_client = RUBG.new(api_key: api_key)

matches = {}
metrics = []

# puts "API call"
players_response = rubg_client.players(shard: shard, query_params: {player_names: "dcfcjoeydcfc,Cevider,JoeARO,EvilMonkeyVenom"})
players_response.players.each do |player|
  latest_match_id = player.match_ids.first
 
  unless past_matches[player.name] == latest_match_id
    if !matches.key?(latest_match_id)
      # puts "API call"
      latest_match = rubg_client.match(shard: shard, query_params: {match_id: latest_match_id})
      matches[latest_match_id] = latest_match
      past_matches[player.name]  = latest_match.match_id
    else
      latest_match = matches[latest_match_id]
    end

    # Process the latest match
    time = Time.parse(latest_match.created).to_i 
    participant = latest_match.participants.select { |participant| participant.player_id == player.player_id}.first
    metrics << match_metric(participant, "dbnos", participant.dbnos, time)
    metrics << match_metric(participant, "kills", participant.kills, time)
    metrics << match_metric(participant, "assists", participant.assists, time)
    metrics << match_metric(participant, "boosts", participant.boosts, time)
    metrics << match_metric(participant, "damage_dealt", participant.damage_dealt, time)
    metrics << match_metric(participant, "headshot_kills", participant.headshot_kills, time)
    metrics << match_metric(participant, "heals", participant.heals, time)
    metrics << match_metric(participant, "longest_kill", participant.longest_kill, time)
    metrics << match_metric(participant, "revives", participant.revives, time)
    metrics << match_metric(participant, "ride_distance", participant.ride_distance, time)
    metrics << match_metric(participant, "road_kills", participant.road_kills, time)
    metrics << match_metric(participant, "time_survived", participant.time_survived, time)
    metrics << match_metric(participant, "vehicle_destroys", participant.vehicle_destroys, time)
    metrics << match_metric(participant, "walk_distance", participant.walk_distance, time)
  end
end

puts metrics
