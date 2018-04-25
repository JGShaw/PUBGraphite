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
      @shroud = subject.players('pc-na', 'shroud').first
    end
  end

  describe '#players' do  
    it 'gets the correct players' do
      VCR.use_cassette('shroud_Wadu') do
        players = subject.players('pc-na', 'shroud,Wadu')
        expect(players[0].name).to eq 'shroud'
        expect(players[1].name).to eq 'Wadu'
        expect(players.length).to eq 2
      end
    end
  end

  describe '#extract' do
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

    context 'a new match has been played and gives the metric' do
      before do
        subject.latest_matches = { @shroud => @second_match.match_id }
        VCR.use_cassette('shroud_match_0') do
          @metrics = subject.extract('pc-na', @shroud)
        end
      end
       
      it 'assists' do
          expect(@metrics).to include('PUBG.shroud.matches.assists 0 1524544931')
      end
      
      it 'boosts' do
          expect(@metrics).to include('PUBG.shroud.matches.boosts 0 1524544931')
      end
      
      it 'damage_dealt' do
          expect(@metrics).to include('PUBG.shroud.matches.damage_dealt 500 1524544931')
      end
      
      it 'dbnos' do
          expect(@metrics).to include('PUBG.shroud.matches.dbnos 3 1524544931')
      end
      
      it 'headshot_kills' do
          expect(@metrics).to include('PUBG.shroud.matches.headshot_kills 2 1524544931')
      end
      
      it 'heals' do
          expect(@metrics).to include('PUBG.shroud.matches.heals 0 1524544931')
      end
      
      it 'kills' do
          expect(@metrics).to include('PUBG.shroud.matches.kills 5 1524544931')
      end
      
      it 'longest_kill' do
          expect(@metrics).to include('PUBG.shroud.matches.longest_kill 33 1524544931')
      end
    
      it 'number_of_teams' do
          expect(@metrics).to include('PUBG.shroud.matches.number_of_teams 49 1524544931')
      end

      it 'rank' do
          expect(@metrics).to include('PUBG.shroud.matches.rank 40 1524544931')
      end
      
      it 'revives' do
          expect(@metrics).to include('PUBG.shroud.matches.revives 0 1524544931')
      end
      
      it 'ride_distance' do
          expect(@metrics).to include('PUBG.shroud.matches.ride_distance 0 1524544931')
      end
      
      it 'road_kills' do
          expect(@metrics).to include('PUBG.shroud.matches.road_kills 0 1524544931')
      end
      
      it 'time_survived' do
          expect(@metrics).to include('PUBG.shroud.matches.time_survived 159 1524544931')
      end
      
      it 'vehicle_destroys' do
          expect(@metrics).to include('PUBG.shroud.matches.vehicle_destroys 0 1524544931')
      end
      
      it 'walk_distance' do
        expect(@metrics).to include('PUBG.shroud.matches.walk_distance 89.03397 1524544931')
      end
    end
  end
  
  describe '#match' do
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

end
