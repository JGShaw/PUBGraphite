# frozen_string_literal: true

require 'metric_extractor'
require 'timecop'

describe MetricExtractor do
  let (:player) { double }
  let (:participant) { double.as_null_object }
  let (:match) { double.as_null_object }
  let (:rosters) { double.as_null_object }
  let (:roster) { double.as_null_object }

  before do
    allow(participant).to receive(:name).and_return('shroud')
    allow(match).to receive(:created).and_return('2018-04-17T12:32:33+00:00')
  end

  context 'Extracting metrics from an API call' do
    it 'gets the dbnos' do
      allow(participant).to receive(:dbnos).and_return(1)
      metrics = subject.extract(player, participant, match)
      expect(metrics).to include('PUBG.shroud.matches.dbnos 1 1523968353')
    end

    it 'gets the kills' do
      allow(participant).to receive(:kills).and_return(2)
      metrics = subject.extract(player, participant, match)
      expect(metrics).to include('PUBG.shroud.matches.kills 2 1523968353')
    end

    it 'gets the assists' do
      allow(participant).to receive(:assists).and_return(3)
      metrics = subject.extract(player, participant, match)
      expect(metrics).to include('PUBG.shroud.matches.assists 3 1523968353')
    end

    it 'gets the boosts' do
      allow(participant).to receive(:boosts).and_return(4)
      metrics = subject.extract(player, participant, match)
      expect(metrics).to include('PUBG.shroud.matches.boosts 4 1523968353')
    end

    it 'gets the damage_dealt' do
      allow(participant).to receive(:damage_dealt).and_return(5)
      metrics = subject.extract(player, participant, match)
      expect(metrics).to include('PUBG.shroud.matches.damage_dealt 5 1523968353')
    end

    it 'gets the headshot_kills' do
      allow(participant).to receive(:headshot_kills).and_return(6)
      metrics = subject.extract(player, participant, match)
      expect(metrics).to include('PUBG.shroud.matches.headshot_kills 6 1523968353')
    end

    it 'gets the heals' do
      allow(participant).to receive(:heals).and_return(7)
      metrics = subject.extract(player, participant, match)
      expect(metrics).to include('PUBG.shroud.matches.heals 7 1523968353')
    end

    it 'gets the longest_kill' do
      allow(participant).to receive(:longest_kill).and_return(8)
      metrics = subject.extract(player, participant, match)
      expect(metrics).to include('PUBG.shroud.matches.longest_kill 8 1523968353')
    end

    it 'gets the revives' do
      allow(participant).to receive(:revives).and_return(9)
      metrics = subject.extract(player, participant, match)
      expect(metrics).to include('PUBG.shroud.matches.revives 9 1523968353')
    end

    it 'gets the ride_distance' do
      allow(participant).to receive(:ride_distance).and_return(10)
      metrics = subject.extract(player, participant, match)
      expect(metrics).to include('PUBG.shroud.matches.ride_distance 10 1523968353')
    end

    it 'gets the road_kills' do
      allow(participant).to receive(:road_kills).and_return(11)
      metrics = subject.extract(player, participant, match)
      expect(metrics).to include('PUBG.shroud.matches.road_kills 11 1523968353')
    end

    it 'gets the time_survived' do
      allow(participant).to receive(:time_survived).and_return(12)
      metrics = subject.extract(player, participant, match)
      expect(metrics).to include('PUBG.shroud.matches.time_survived 12 1523968353')
    end

    it 'gets the vehicle_destroys' do
      allow(participant).to receive(:vehicle_destroys).and_return(13)
      metrics = subject.extract(player, participant, match)
      expect(metrics).to include('PUBG.shroud.matches.vehicle_destroys 13 1523968353')
    end

    it 'gets the walk_distance' do
      allow(participant).to receive(:walk_distance).and_return(14)
      metrics = subject.extract(player, participant, match)
      expect(metrics).to include('PUBG.shroud.matches.walk_distance 14 1523968353')
    end

    it 'gets the number_of_teams' do
      allow(match).to receive(:rosters).and_return(rosters)
      allow(rosters).to receive(:length).and_return(15)
      metrics = subject.extract(player, participant, match)
      expect(metrics).to include('PUBG.shroud.matches.number_of_teams 15 1523968353')
    end

    it 'gets the rank' do
      allow(match).to receive(:rosters).and_return(rosters)
      allow(rosters).to receive(:find).and_return(roster)
      allow(roster).to receive(:rank).and_return(16)

      metrics = subject.extract(player, participant, match)
      expect(metrics).to include('PUBG.shroud.matches.rank 16 1523968353')
    end
  end
end
