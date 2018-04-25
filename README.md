# PUBGraphite

This project uses the [RUBG gem](https://github.com/dor-edras/RUBG) to query the PUBG API and convert its results into graphite metrics. It will then send the metrics to a graphite server using TCP. The script loops forever, querying the API for new games for all of the players specified every 2 minutes.

## Running the script
```
ruby lib/run.rb <<YOUR API KEY>> <<GRAPHITE IP>> <<GRAPHITE PORT>> <<SHARD>> <<PLAYER NAMES>>
```

The shard is the region you wish to query, please check the PUBG api for a list of [available regions](https://documentation.playbattlegrounds.com/en/making-requests.html#regions).

The player names should be seperated by commas with no spaces, e.g. `shroud,wadu,...`. These names are case sensitive.

## Example metrics
```
PUBG.shroud.matches.assists 0 1524544931
PUBG.shroud.matches.boosts 0 1524544931
PUBG.shroud.matches.damage_dealt 500 1524544931
PUBG.shroud.matches.dbnos 3 1524544931
PUBG.shroud.matches.headshot_kills 2 1524544931
PUBG.shroud.matches.heals 0 1524544931
PUBG.shroud.matches.kills 5 1524544931
PUBG.shroud.matches.longest_kill 33 1524544931
PUBG.shroud.matches.number_of_teams 49 1524544931
PUBG.shroud.matches.rank 40 1524544931
PUBG.shroud.matches.revives 0 1524544931
PUBG.shroud.matches.ride_distance 0 1524544931
PUBG.shroud.matches.road_kills 0 1524544931
PUBG.shroud.matches.time_survived 159 1524544931
PUBG.shroud.matches.vehicle_destroys 0 1524544931
PUBG.shroud.matches.walk_distance 89.03397 1524544931
```

## Running the tests
The tests are written using Rspec, and use [VCR](https://github.com/vcr/vcr) to record and save the HTTP interactions between the RUBG gem and the PUBG API. The cassettes are located in `spec/cassettes`. If new recordings are required then delete the files in this folder, and update the values expected in the tests for all of the metrics.
