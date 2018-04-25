require 'rubg'

class MetricExtractor

  attr_accessor :latest_matches

  def initialize(api_key)
    @latest_matches = {}
    @client = RUBG.new(api_key: api_key)
  end

  def players(shard, player_names)
    @client.players(shard: shard, query_params: { player_names: player_names })
  end

  def extract(shard, player)
    return [] if player.match_ids.first == latest_matches[player] 
    
    last_match = match(shard, player, 0)
    
    time = Time.parse(last_match.created).to_i
    participant = last_match.participants.select { |participant| participant.player_id == player.player_id }.first
    metrics = []
    metrics << match_metric(participant, 'assists', participant.assists, time)
    metrics << match_metric(participant, 'boosts', participant.boosts, time)
    metrics << match_metric(participant, 'damage_dealt', participant.damage_dealt, time)
    metrics << match_metric(participant, 'dbnos', participant.dbnos, time)
    metrics << match_metric(participant, 'headshot_kills', participant.headshot_kills, time)
    metrics << match_metric(participant, 'heals', participant.heals, time)
    metrics << match_metric(participant, 'kills', participant.kills, time)
    metrics << match_metric(participant, 'longest_kill', participant.longest_kill, time)
    metrics << match_metric(participant, 'number_of_teams', last_match.rosters.length, time)
    
    player_roster = last_match.rosters.find { |roster| roster.participants.member?(participant) }
    metrics << match_metric(participant, 'rank', player_roster.rank, time)
    
    metrics << match_metric(participant, 'revives', participant.revives, time)
    metrics << match_metric(participant, 'ride_distance', participant.ride_distance, time)
    metrics << match_metric(participant, 'road_kills', participant.road_kills, time)
    metrics << match_metric(participant, 'time_survived', participant.time_survived, time)
    metrics << match_metric(participant, 'vehicle_destroys', participant.vehicle_destroys, time)
    metrics << match_metric(participant, 'walk_distance', participant.walk_distance, time)
    metrics
  end

  def match(shard, player, index)
    @client.match(shard: shard, query_params: { match_id: player.match_ids[index] })
  end
  
  private

  def match_metric(participant, stat_name, stat, time)
    "PUBG.#{participant.name}.matches.#{stat_name} #{stat} #{time}"
  end
end
