<h3>Oddschecker event Scraper</h3>
A simple Ruby script which will get a valid Oddschecker event URL and it will return the event data in JSON format.
The script will use nokogiri and open-uri gems in order to scrape the data.

<h6>JSON format:</h6>

```
{
  "bookie":"Matchbook",
  "name":"apoel nicosia",
  "bet_type":"winner",
  "decimal_odds":"10.9",
  "fractional_odds":"49/5"
}
```

<h3>How to run</h3>

```
ruby scrape_oddschecker_event.rb #{VALID_ODDSCHECKER_GAME_URL}
```
