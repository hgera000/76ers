
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
#real	3m2.486s


#quick checks on the data extracted
cd ../data
wc -l odds_and_spreads.csv 
#5650 odds_and_spreads.csv
cut -d',' -f1 odds_and_spreads.csv | sort -u | wc -l
#369
cut -d',' -f1 odds_and_spreads.csv | sort | uniq -c | sort -nr | head
#     29 connecticut
#     28 providence
#     28 depaul
#     27 maryland
#     26 wisconsin
#     26 west virginia
#     26 baylor
#     25 virginia
#     25 south florida
#     25 minnesota




#here is where would 'load data infile' into MySQL. 

#for now, extract team name, score, odds, spread, date, id, home/away 

cut -d',' -f1,2,7,8,24,25,26 odds_and_spreads.csv > cut_data.csv

#take this across to R for analysis

