require 'metric_extractor'
require 'timecop'

describe MetricExtractor do
  let (:player) { double }
  let (:participant) { double }
  let (:match) { double }
  
  before do
    allow(participant).to receive(:name).and_return("shroud")
    allow(participant).to receive(:dbnos).and_return(1)
    allow(participant).to receive(:kills).and_return(2)
    allow(participant).to receive(:assists).and_return(3)
    allow(participant).to receive(:boosts).and_return(4)
    allow(participant).to receive(:damage_dealt).and_return(5)
    allow(participant).to receive(:headshot_kills).and_return(6)
    allow(participant).to receive(:heals).and_return(7)
    allow(participant).to receive(:longest_kill).and_return(8)
    allow(participant).to receive(:revives).and_return(9)
    allow(participant).to receive(:ride_distance).and_return(10)
    allow(participant).to receive(:road_kills).and_return(11)
    allow(participant).to receive(:time_survived).and_return(12)
    allow(participant).to receive(:vehicle_destroys).and_return(13)
    allow(participant).to receive(:walk_distance).and_return(14)
    
      allow(match).to receive(:created).and_return("2018-04-17T12:32:33+00:00")
    @metrics = subject.extract(player, participant, match)
  end

  context 'Extracting metrics from an API call' do
    it 'gets the dbnos' do
      expect(@metrics).to include("PUBG.shroud.matches.dbnos 1 1523968353")
    end
    
    it 'gets the kills' do
      expect(@metrics).to include("PUBG.shroud.matches.kills 2 1523968353")
    end
    
    it 'gets the assists' do
      expect(@metrics).to include("PUBG.shroud.matches.assists 3 1523968353")
    end
    
    it 'gets the boosts' do
      expect(@metrics).to include("PUBG.shroud.matches.boosts 4 1523968353")
    end
    
    it 'gets the damage_dealt' do
      expect(@metrics).to include("PUBG.shroud.matches.damage_dealt 5 1523968353")
    end
    
    it 'gets the headshot_kills' do
      expect(@metrics).to include("PUBG.shroud.matches.headshot_kills 6 1523968353")
    end

    it 'gets the heals' do
      expect(@metrics).to include("PUBG.shroud.matches.heals 7 1523968353")
    end
    
    it 'gets the longest_kill' do
      expect(@metrics).to include("PUBG.shroud.matches.longest_kill 8 1523968353")
    end
    
    it 'gets the revives' do
      expect(@metrics).to include("PUBG.shroud.matches.revives 9 1523968353")
    end
    
    it 'gets the ride_distance' do
      expect(@metrics).to include("PUBG.shroud.matches.ride_distance 10 1523968353")
    end
    
    it 'gets the road_kills' do
      expect(@metrics).to include("PUBG.shroud.matches.road_kills 11 1523968353")
    end
    
    it 'gets the time_survived' do
      expect(@metrics).to include("PUBG.shroud.matches.time_survived 12 1523968353")
    end
    
    it 'gets the vehicle_destroys' do
      expect(@metrics).to include("PUBG.shroud.matches.vehicle_destroys 13 1523968353")
    end
    
    it 'gets the walk_distance' do
      expect(@metrics).to include("PUBG.shroud.matches.walk_distance 14 1523968353")
    end
  end

      # metrics << match_metric(participant, "headshot_kills", participant.headshot_kills, time)
      # metrics << match_metric(participant, "heals", participant.heals, time)
      # metrics << match_metric(participant, "longest_kill", participant.longest_kill, time)
      # metrics << match_metric(participant, "revives", participant.revives, time)
      # metrics << match_metric(participant, "ride_distance", participant.ride_distance, time)
      # metrics << match_metric(participant, "road_kills", participant.road_kills, time)
      # metrics << match_metric(participant, "time_survived", participant.time_survived, time)
      # metrics << match_metric(participant, "vehicle_destroys", participant.vehicle_destroys, time)
      # metrics << match_metric(participant, "walk_distance", participant.walk_distance, time)
end
