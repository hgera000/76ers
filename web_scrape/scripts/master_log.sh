
cd ~/76ers/web_scrape/scripts

#scrape html for all dates in 2013/14 season
time python get_html.py 
#The html table for date 20131108 has been saved.
#The html table for date 20131109 has been saved.
#The html table for date 20131110 has been saved.
#The html table for date 20131111 has been saved.
#...
#The html table for date 20140314 has been saved.
#The html table for date 20140315 has been saved.
#The html table for date 20140316 has been saved.
#The html table for date 20140317 has been saved.
#real	14m12.986s

#parse saved html and produce raw csv file
time python parse_html.py > ../data/odds_and_spreads.csv
#real	8m9.714s

#quick checks on the data extracted
cd ../data
wc -l odds_and_spreads.csv 
#15080 rows (~7500 matches)
cut -d',' -f1 odds_and_spreads.csv | sort -u | wc -l
#116 unique teams
cut -d',' -f1 odds_and_spreads.csv | sort | uniq -c | sort | head
#    130 air force
#    130 alabama
#    130 american u
#    130 appalachian st
#    130 arizona
#    130 arkansas
#    130 army
#    130 baylor
#    130 belmont
#    130 boise st




#here is where would 'load data infile' into MySQL. 

#for now, extract team name, score, odds, spread, date, id, home/away 

cut -d',' -f1,2,7,8,24,25,26 odds_and_spreads.csv > cut_data.csv

#take this across to R for analysis

