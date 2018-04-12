# PUBGraphite

This project uses the [RUBG gem](https://github.com/dor-edras/RUBG) to query the PUBG API and convert its results into graphite metrics. It will then send the metrics to a graphite server using TCP. The script loops forever, querying the API for new games for all of the players specified every 2 minutes.

## Running the script
```
ruby lib/run.rb <<YOUR API KEY>> <<GRAPHITE IP>> <<GRAPHITE PORT>> <<SHARD>> <<PLAYER NAMES>>
```

The shard is the region you wish to query, please check the PUBG api for a list of [available regions](https://documentation.playbattlegrounds.com/en/making-requests.html#regions).

The player names should be seperated by commas with no spaces, e.g. `shroud,wadu,...`. These names are case sensitive.
