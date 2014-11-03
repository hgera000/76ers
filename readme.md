# 76ers Data Task Readme #

Author: Hugo Gerard

This readme file provides background and motivation for my analsis. The data source, scripts, and the exact commands run generate my results are also detailed below, along with a discussion of caveats and possible extensions. 

## 1. Summary ##

### Question ###
Which teams out-performed or under-performed relative to 'market expectations' in the 2013-14 NCAA season? Can this metric signal the teams, and their players, worthy of closer attention in the 2015 draft?

### Outline and Methodology ###
The key premise of this analysis is to use online betting markets to measure aggregated market expectations about how a team will perform. Online betting markets or 'prediction markets' have been shown to efficiently aggregate information and offer accurate predictions, on average, about the outcome of future events (often referred to as the 'wisdom of crowds'). 

Betting market participants form their beliefs incorporating a wide range of information, including media commentary, statistics, and inside information. In this analysis we use these aggregated beliefs (in the form of market prices) to provide a benchmark for how different teams were expected to perform throughout the 2013-14 season. 

To do this, for each team in the 2013/14 NCAA regular season, we calculate the return to investing $1 on that team to 'beat the spread' in every game. A team which performs 'as expected' would generate a return of 0% (after giving back any market commissions). However, a team that performs surprisingly well, would generate a positive return over the season (note that a team who performs surprisingly well according to this metric might still have performed poorly in an absolute sense). 

The teams that out-performed the most (their performance was a surprise to the market) could warrant closer attention when considering the 2015 draft class. In particular, since their performance was (by definition according this metric) a surprise, it could be the case that certain players on these teams have been paid less attention in the media and may have flown 'under the radar' and as such could represent high-value draft prospects.

### Results, Caveats and Extensions

The figure [final_figure.png](final_figure.png) show the top 10 over- and under-performing teams according to the metric described above. These teams are worth closer attention (including an analysis of individual player statistics) to investigate why their performances were such as surprise to the betting markets and what this might mean for relative player valuations in the 2015 draft.  

A key caveat to this analysis is that only a team as a whole can be evaluated relative to market expectations, not individual players. This is a significant limitation when trying to evaluate upcoming draft picks. To the extend that certain headline players might dominate both media attention (informing market opinions) and overall team performance, team and player valuations according to this metric should be correlated. Though the methodology is perhaps better suited to be used as a flag for which teams could deserve a greater focus and in-depth analysis using player-by-player statistics to determine which players contributed the most to their team's surprising 2013-14 performance. 

It is left as an extension to investigate historically the predictive content of the metrics constructed here and their ability to predict under or over valued draft prospects 'out of sample.' For example, would this metric constructed over the course of the 2012-13 season have flagged teams and their players who later proved to be high-value draft selections? 

It is also left as an extension to replicate this analysis day-by-day in the 2014-15 season as a means to flag the teams out-performing market expectations at the present time.
 

## 2. Data ##

Betting market data was scraped from [www.sbrodds.com/ncaa)](www.sbrodds.com/ncaa]) for all games of the 2013-14 college basketball season and for all teams. The key variables collected were:

- __spread__ (the number of points handicap assigned by the online betting site. For example, if a team is heavily favored to win the match, they might be assigned a -9.5pt handicap, indicating they need to win by 10pts or more for them to 'cover the spread'). 

- __odds__ (the final betting odds for each team at the given spread. These are typically close to 50-50 given the nature of spread betting). 

- __team name__
-  __final score__

The resulting data obtained consisted of 2825 games (5650 rows), though not all games have betting odds and spreads available. 

## 3. Scripts ##

- [get_html.py](web_scrape/scripts/get_html.py) `Python` script to loop through every day of the 2013-14 season and save the corresponding `html` into individual files.

To run from shell:
`python get_html.py`
Output:

```The html table for date 20131108 has been saved.```
```The html table for date 20131109 has been saved.```
```The html table for date 20131110 has been saved.```
```The html table for date 20131111 has been saved.```

- [parse_html.py](web_scrape/scripts/parse_html.py) `Python` script which loops through the individual files saved by `get_html.py` and parses the `html` to extract the relevant data. A final `csv` file is printed to `stdout` with the data. The `python` package `BeautifulSoup` is used to parse the `html`.

To run from shell:
`python parse_html.py > ../data/odds.csv`
`cut -d',' -f1,2,7,8,24,25,26 odds_and_spreads.csv > cut_data.csv`

Example Output:

```head cut_data.csv```

| east tennessee st | 75 | -110 | +12.5 | 20131108 | 1 | away |
|-------------------|----|------|-------|----------|---|------|
| charlotte         | 80 | -110 | -12.5 | 20131108 | 1 | home |
| presbyterian      | 57 | -110 | +17.5 | 20131108 | 2 | away |
| georgia tech      | 88 | \N   | \N    | 20131108 | 2 | home |
| navy              | \N | -110 | +12.5 | 20131108 | 3 | away |
| towson            | \N | -110 | -12.5 | 20131108 | 3 | home |
| mount st mary's   | 62 | -110 | +11.5 | 20131108 | 4 | away |
| west virginia     | 77 | -110 | -11.5 | 20131108 | 4 | home |
| lehigh            | \N | -110 | +15.5 | 20131108 | 5 | away |
| minnesota         | \N | -110 | -15.5 | 20131108 | 5 | home |

- [analysis.R](analysis.R) `R` script which loads the `csv` file created by `parse_html.py`, performs a few manipulations to the data, and then calculates the top out-performing teams. The results are also graphed in this script using `ggplot2`.

- [master_log.sh](web_scrape/scripts/master_log.sh) `bash` log file where the exact commands run were stored. 

Note: A database such as `MySQL` would typically be included in into the work-flow above. That is, after extracting data in `csv` format from the raw `html` it could be added to a `MySQL` database (`load data infile`). 