#script to loop over dates and save html of odds and spread from sbrodds.com

from BeautifulSoup import BeautifulSoup
from datetime import datetime, timedelta
import requests,os,pdb

base = "http://www.sportsbookreview.com/betting-odds/ncaa-basketball/?date=%s"
folder = "~/76ers/web_scrape/data/html/" #include trainling slash!

#create list of dates for the 2013/14 season
start = datetime.strptime('2013-11-08','%Y-%m-%d')
dates = [start + timedelta(days=x) for x in range(0, 2)] #130 for end date 2014-03-17 (not including playoffs here). 

#now loop through the dates and save the html to a folder
#better to save the html and then parse than to parse on the fly - avoids unecessary hits to the website when debugging parsing script.

for dt in dates:
    dt = dt.strftime('%Y%m%d') #format needed for url. 
    #pdb.set_trace()
    resp = requests.get(base % dt)
    soup = BeautifulSoup(resp.text)
    #keep only the table of interest in the html
    table = soup.find('div',{'class': 'eventLines'})
    with file(os.path.expanduser(folder)+dt+".html","w") as fname:
        fname.write(str(table))
        print "The html table for date %s has been saved." % dt


