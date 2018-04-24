require 'metric_extractor'
require 'timecop'
require 'vcr'

describe MetricExtractor do

  subject { MetricExtractor.new ENV['PUBG_API_KEY'] }

  before do
    VCR.configure do |config|
      config.cassette_library_dir = "spec/cassettes"
      config.hook_into :webmock
      config.filter_sensitive_data('<API_KEY>') { ENV['PUBG_API_KEY'] }
    end
    
    VCR.use_cassette('shroud') do
      @shroud = subject.players('pc-na', 'shroud').players.first
    end
  end

  context '#players' do  
    it 'gets the correct players' do
      VCR.use_cassette('shroud_Wadu') do
        players = subject.players('pc-na', 'shroud,Wadu').players
        expect(players[0].name).to eq 'shroud'
        expect(players[1].name).to eq 'Wadu'
        expect(players.length).to eq 2
      end
    end
  end

  context '#extract' do     

    before do
      VCR.use_cassette('shroud_match_0') do
        @first_match = subject.match('pc-na', @shroud, 0)
      end
      VCR.use_cassette('shroud_match_1') do
        @second_match = subject.match('pc-na', @shroud, 1)
      end
    end

    context 'the latest match has not changed' do
      before do
        subject.latest_matches = { @shroud => @first_match.match_id }
      end

      it 'returns no metrics' do
        expect(subject.extract('pc-na', @shroud)).to be_empty 
      end
    end

    context 'a new match has been played' do
      before do
        @seconds_ma
        subject.latest_matches = { @shroud => @second_match.match_id }
        VCR.use_cassette('shroud_match_0') do
          @metrics = subject.extract('pc-na', @shroud)
        end
      end
     
      it 'returns the dbnos metric' do
          expect(@metrics).to include('PUBG.shroud.matches.dbnos 3 1524544931')
      end
      
      it 'returns the kills metric' do
          expect(@metrics).to include('PUBG.shroud.matches.kills 5 1524544931')
      end
      
      it 'returns the assists metric' do
          expect(@metrics).to include('PUBG.shroud.matches.assists 0 1524544931')
      end
    end
  end
  
  context '#match' do
    it 'can get the first match' do
      VCR.use_cassette('shroud_match_0') do
        match = subject.match('pc-na', @shroud, 0)
        expect(match.match_id).to eq "aa089c48-b7e0-4ba9-8e57-f27e195012a1"
      end
    end

    it 'can get the second match' do
      VCR.use_cassette('shroud_match_1') do
        match = subject.match('pc-na', @shroud, 1)
        expect(match.match_id).to eq "2997f2b8-c262-4948-a28c-432f8121a5e6"
      end
    end
  end

  # context '#extract' do
    # it 'gets the dbnos' do
      # allow(participant).to receive(:dbnos).and_return(1)
      # metrics = subject.extract(player, participant, match)
      # expect(metrics).to include('PUBG.shroud.matches.dbnos 1 1523968353')
    # end

    # it 'gets the kills' do
      # allow(participant).to receive(:kills).and_return(2)
      # metrics = subject.extract(player, participant, match)
      # expect(metrics).to include('PUBG.shroud.matches.kills 2 1523968353')
    # end

    # it 'gets the assists' do
      # allow(participant).to receive(:assists).and_return(3)
      # metrics = subject.extract(player, participant, match)
      # expect(metrics).to include('PUBG.shroud.matches.assists 3 1523968353')
    # end

    # it 'gets the boosts' do
      # allow(participant).to receive(:boosts).and_return(4)
      # metrics = subject.extract(player, participant, match)
      # expect(metrics).to include('PUBG.shroud.matches.boosts 4 1523968353')
    # end

    # it 'gets the damage_dealt' do
      # allow(participant).to receive(:damage_dealt).and_return(5)
      # metrics = subject.extract(player, participant, match)
      # expect(metrics).to include('PUBG.shroud.matches.damage_dealt 5 1523968353')
    # end

    # it 'gets the headshot_kills' do
      # allow(participant).to receive(:headshot_kills).and_return(6)
      # metrics = subject.extract(player, participant, match)
      # expect(metrics).to include('PUBG.shroud.matches.headshot_kills 6 1523968353')
    # end

    # it 'gets the heals' do
      # allow(participant).to receive(:heals).and_return(7)
      # metrics = subject.extract(player, participant, match)
      # expect(metrics).to include('PUBG.shroud.matches.heals 7 1523968353')
    # end

    # it 'gets the longest_kill' do
      # allow(participant).to receive(:longest_kill).and_return(8)
      # metrics = subject.extract(player, participant, match)
      # expect(metrics).to include('PUBG.shroud.matches.longest_kill 8 1523968353')
    # end

    # it 'gets the revives' do
      # allow(participant).to receive(:revives).and_return(9)
      # metrics = subject.extract(player, participant, match)
      # expect(metrics).to include('PUBG.shroud.matches.revives 9 1523968353')
    # end

    # it 'gets the ride_distance' do
      # allow(participant).to receive(:ride_distance).and_return(10)
      # metrics = subject.extract(player, participant, match)
      # expect(metrics).to include('PUBG.shroud.matches.ride_distance 10 1523968353')
    # end

    # it 'gets the road_kills' do
      # allow(participant).to receive(:road_kills).and_return(11)
      # metrics = subject.extract(player, participant, match)
      # expect(metrics).to include('PUBG.shroud.matches.road_kills 11 1523968353')
    # end

    # it 'gets the time_survived' do
      # allow(participant).to receive(:time_survived).and_return(12)
      # metrics = subject.extract(player, participant, match)
      # expect(metrics).to include('PUBG.shroud.matches.time_survived 12 1523968353')
    # end

    # it 'gets the vehicle_destroys' do
      # allow(participant).to receive(:vehicle_destroys).and_return(13)
      # metrics = subject.extract(player, participant, match)
      # expect(metrics).to include('PUBG.shroud.matches.vehicle_destroys 13 1523968353')
    # end

    # it 'gets the walk_distance' do
      # allow(participant).to receive(:walk_distance).and_return(14)
      # metrics = subject.extract(player, participant, match)
      # expect(metrics).to include('PUBG.shroud.matches.walk_distance 14 1523968353')
    # end

    # it 'gets the number_of_teams' do
      # allow(match).to receive(:rosters).and_return(rosters)
      # allow(rosters).to receive(:length).and_return(15)
      # metrics = subject.extract(player, participant, match)
      # expect(metrics).to include('PUBG.shroud.matches.number_of_teams 15 1523968353')
    # end

    # it 'gets the rank' do
      # allow(match).to receive(:rosters).and_return(rosters)
      # allow(rosters).to receive(:find).and_return(roster)
      # allow(roster).to receive(:rank).and_return(16)

      # metrics = subject.extract(player, participant, match)
      # expect(metrics).to include('PUBG.shroud.matches.rank 16 1523968353')
    # end
  # end
end
