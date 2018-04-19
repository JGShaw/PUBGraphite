module MetricExtractor 
  def self.extract player, participant, match
    time = Time.parse(match.created).to_i 
    metrics = []
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
      
    metrics << match_metric(participant, "number_of_teams", match.rosters.length, time)
    
    player_roster = match.rosters.find { |roster| roster.participants.member?(participant) }
    metrics << match_metric(participant, 'rank', player_roster.rank, time)
    
    metrics
  end

  private

  def self.match_metric(participant, stat_name, stat, time)
    "PUBG.#{ participant.name }.matches.#{ stat_name } #{ stat } #{ time }"
  end
end
